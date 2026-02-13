import Flutter
import UIKit
import AVFoundation
import UserNotifications
import CallKit
import PushKit
import SQLite3

@main
@objc class AppDelegate: FlutterAppDelegate {
    
    // Extracted components
    private let fakeCallOverlay = FakeCallOverlay()
    private let alarmManager = AlarmManager()
    
    // CallKit & Services
    private var callController = CXCallController()
    private var providerDelegate: ProviderDelegate?
    private var pushRegistry: PKPushRegistry?
    
    // Channels
    private var methodChannel: FlutterMethodChannel?
    private var voipChannel: FlutterMethodChannel?
    private var storedVoipToken: String?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        methodChannel = FlutterMethodChannel(name: "com.raidalarm.voip",
                                              binaryMessenger: controller.binaryMessenger)
        
        // Setup VoIP method channel for token retrieval
        voipChannel = FlutterMethodChannel(name: "com.raidalarm/voip",
                                           binaryMessenger: controller.binaryMessenger)
        
        // Handle VoIP token requests from Flutter
        voipChannel?.setMethodCallHandler { [weak self] (call, result) in
            if call.method == "getVoipToken" {
                result(self?.storedVoipToken)
            } else {
                result(FlutterMethodNotImplemented)
            }
        }
        
        // 1. Setup Audio
        alarmManager.setupAudioSession()
        
        // Ensure UI dismisses if Alarm stops (e.g. Duration Timer ends)
        alarmManager.onStop = { [weak self] in
            DispatchQueue.main.async {
                self?.fakeCallOverlay.dismissFakeCall()
            }
        }
        
        // 2. Setup CallKit Provider
        providerDelegate = ProviderDelegate(callManager: callController)
        
        // 3. Setup VoIP Push Registry
        pushRegistry = PKPushRegistry(queue: .main)
        pushRegistry?.delegate = self
        pushRegistry?.desiredPushTypes = [.voIP]
        
        // 4. Register for Standard Notifications (Fallback)
        UNUserNotificationCenter.current().delegate = self
        // Removed automatic authorization request to allow Flutter side to handle it contextually
        // UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in ... }
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    // MARK: - Standard Remote Notification (Fallback / Info Update)
    override func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable : Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        // Trigger logic based on Server Payload
        // Check for 'channelId' == 'alarm' OR 'type' == 'alarm'
        let channelId = userInfo["channelId"] as? String
        let type = userInfo["type"] as? String
        let androidChannelId = userInfo["gcm.notification.android_channel_id"] as? String // Optional check
        
        if channelId == "alarm" || type == "alarm" || androidChannelId == "alarm" {
             print("🔔 Alarm Triggered via Notification (Channel: \(channelId ?? "nil"), Type: \(type ?? "nil"))")
             
             // 1. Record Attack Stats
             SettingsManager.shared.recordAttack()
             
             // 2. Handle Payload (Play Sound, Show UI)
             handleRaidPayload(userInfo)
        }
        completionHandler(.newData)
    }
    
    func handleRaidPayload(_ payload: [AnyHashable: Any]) {
        let title = payload["title"] as? String ?? "RAID ALERT"
        
        // 1. Get Settings from SQLite using new Manager
        let settings = SettingsManager.shared.getSQLiteAlarmSettings()
        
        let fakeCallEnabled = settings["fakeCallEnabled"] as? Bool ?? false
        let mode = settings["mode"] as? String ?? "sound"
        
        // Extra Settings
        let vibrate = settings["vibration"] as? Bool ?? true
        let duration = settings["duration"] as? Double ?? 30.0
        let loop = settings["infiniteLoop"] as? Bool ?? true
        
        // Custom Sound & Background Logic
        let customAlarmSoundPath = settings["alarmSound"] as? String
        let customFakeCallSoundPath = settings["fakeCallSound"] as? String
        let customBackgroundPath = settings["fakeCallBackground"] as? String
        
        let callerName = settings["fakeCallerName"] as? String ?? title
        
        // 1.1 Save Notification to History (Sync with Flutter UI)
        // We use the 'body' from payload if available, or generate a default message
        let body = payload["body"] as? String ?? "Your base is under attack!"
        let channelId = payload["channelId"] as? String ?? "alarm"
        
        SettingsManager.shared.saveNotification(
            title: title,
            body: body,
            channelId: channelId
        )
        
        DispatchQueue.main.async {
            // 2. Play Sound (if mode is sound or vibration)
            // Note: Our AlarmManager now handles vibration internally if 'vibrate' is true
            // regardless of mode string, but we should respect 'silent' mode too.
            
            if mode != "silent" {
                let soundPath = fakeCallEnabled ? customFakeCallSoundPath : customAlarmSoundPath
                self.alarmManager.playCustomSound(
                    soundPath,
                    defaultName: "raid_alarm",
                    vibrate: vibrate,
                    duration: duration,
                    loop: loop
                )
            } else if vibrate {
                // If silent but vibrate is ON (if app logic allows silent+vibrate)
                 // For now, if mode is silent, we might just want vibration?
                 // Let's assume 'silent' means NO sound. But maybe Vibration?
                 // The 'mode' in SQLite might be 'sound', 'vibrate', 'silent'.
                 if mode == "vibrate" {
                     self.alarmManager.playCustomSound(
                         nil, // No sound
                         defaultName: "raid_alarm",
                         vibrate: true,
                         duration: duration,
                         loop: loop
                     )
                 }
            }
            
            // 3. Show Overlay (if enabled)
            if fakeCallEnabled {
                // Load custom image if exists
                var customImage: UIImage?
                if let bgPath = customBackgroundPath, FileManager.default.fileExists(atPath: bgPath) {
                    customImage = UIImage(contentsOfFile: bgPath)
                }
                
                self.fakeCallOverlay.showFakeCall(callerName: callerName, image: customImage)
                
                // IMPORTANT: Handle Dismissal to Stop Sound
                self.fakeCallOverlay.onDismiss = { [weak self] in
                    print("🔕 Fake Call Dismissed. Stopping Sound.")
                    self?.alarmManager.stopSound()
                }
            }
        }
    }
}

// MARK: - VoIP Push Delegate
extension AppDelegate: PKPushRegistryDelegate {
    
    // Obsolete but required protocol stub (empty)
    // func pushRegistry(_ registry: PKPushRegistry, didUpdate descriptors: PKPushCredentials, for type: PKPushType) {}
    
    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
        let token = pushCredentials.token.map { String(format: "%02x", $0) }.joined()
        print("📱 VoIP Token: \(token)")
        
        // Store token for later retrieval
        storedVoipToken = token
        
        // Send to Flutter
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.methodChannel?.invokeMethod("onVoipToken", arguments: token)
        }
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        print("📨 VoIP Push Received: \(payload.dictionaryPayload)")
        
        let dict = payload.dictionaryPayload
        let handle = dict["title"] as? String ?? "Raid Alert"
        let uuid = UUID()
        
        // 1. Report to CallKit (System Requirement)
        providerDelegate?.reportIncomingCall(uuid: uuid, handle: handle, completion: { [weak self] in
            // 2. Show Custom Overlay on top
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self?.handleRaidPayload(dict)
            }
            completion()
        })
    }
}

