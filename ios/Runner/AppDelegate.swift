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

// MARK: - CallKit Provider Delegate
class ProviderDelegate: NSObject, CXProviderDelegate {
    private let provider: CXProvider
    private let callController: CXCallController
    
    init(callManager: CXCallController) {
        self.callController = callManager
        let config = CXProviderConfiguration(localizedName: "Raid Alarm")
        config.supportsVideo = false
        config.maximumCallsPerCallGroup = 1
        config.supportedHandleTypes = [.generic]
        config.ringtoneSound = "raid_alarm.caf" // Ensure this file is in Bundle
        
        // Optional: Set Icon
        // config.iconTemplateImageData = UIImage(named: "AppIcon")?.pngData()
        
        self.provider = CXProvider(configuration: config)
        super.init()
        self.provider.setDelegate(self, queue: nil)
    }
    
    func reportIncomingCall(uuid: UUID, handle: String, completion: @escaping () -> Void) {
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .generic, value: handle)
        update.localizedCallerName = handle
        update.hasVideo = false
        
        provider.reportNewIncomingCall(with: uuid, update: update) { error in
            if error == nil {
                print("✅ CallKit Reported Incoming Call")
                completion()
            } else {
                print("❌ CallKit Error: \(String(describing: error))")
                completion()
            }
        }
    }
    
    func providerDidReset(_ provider: CXProvider) { }
    
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        print("✅ Call Answered")
        // Stop audio, dismiss overlay -> Open App
        action.fulfill()
        // Here you would typically navigate to the specific screen in Flutter
    }
    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        print("❌ Call Ended")
        // Stop audio, dismiss overlay
        action.fulfill()
    }
}

// MARK: - Fake Call Overlay Manager
class FakeCallOverlay {
    private var overlayWindow: UIWindow?
    
    func showFakeCall(callerName: String, image: UIImage? = nil) {
        guard let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive || $0.activationState == .foregroundInactive || $0.activationState == .background }) as? UIWindowScene 
        else { return }
        
        if overlayWindow != nil { return }
        
        overlayWindow = UIWindow(windowScene: windowScene)
        overlayWindow?.windowLevel = .alert + 1
        overlayWindow?.backgroundColor = .clear // Transparent to see CallKit or Black?
        
        // User requested full screen overlay like Android
        let fakeCallVC = FakeCallViewController()
        fakeCallVC.callerName = callerName
        fakeCallVC.callerImage = image
        fakeCallVC.onDismiss = { [weak self] in
            self?.dismissFakeCall()
        }
        
        overlayWindow?.rootViewController = fakeCallVC
        overlayWindow?.isHidden = false
        overlayWindow?.makeKeyAndVisible()
    }
    
    func dismissFakeCall() {
        UIView.animate(withDuration: 0.3, animations: {
            self.overlayWindow?.alpha = 0
        }) { _ in
            self.overlayWindow?.isHidden = true
            self.overlayWindow = nil
        }
    }
}

// MARK: - Fake Call View Controller
class FakeCallViewController: UIViewController {
    var callerName: String = "RAID ALERT"
    var callerImage: UIImage?
    var onDismiss: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.05, green: 0.05, blue: 0.05, alpha: 1.0)
        
        // Avatar
        let avatarContainer = UIView()
        avatarContainer.backgroundColor = UIColor(red: 0.15, green: 0.15, blue: 0.16, alpha: 1.0)
        avatarContainer.layer.cornerRadius = 60
        avatarContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarContainer)
        
        let iconView = UIImageView(image: callerImage ?? UIImage(systemName: "exclamationmark.triangle.fill"))
        iconView.tintColor = .systemRed
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        // Clip to bounds if it is a custom image to respect corner radius logic if we wanted circular
        // But for container logic:
        if callerImage != nil {
             iconView.layer.cornerRadius = 60
             iconView.clipsToBounds = true
             // Ensure it fills the circle
             iconView.contentMode = .scaleAspectFill
        }
        
        avatarContainer.addSubview(iconView)
        
        // Labels
        let nameLabel = UILabel()
        nameLabel.text = callerName
        nameLabel.font = .systemFont(ofSize: 32, weight: .heavy)
        nameLabel.textColor = .white
        nameLabel.textAlignment = .center
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        let subLabel = UILabel()
        subLabel.text = "BASE UNDER ATTACK"
        subLabel.font = .systemFont(ofSize: 16, weight: .medium)
        subLabel.textColor = .systemRed
        subLabel.textAlignment = .center
        subLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(subLabel)
        
        // Buttons
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 40
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        
        let declineBtn = createButton(title: "Ignore", color: .systemRed, icon: "phone.down.fill")
        declineBtn.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        
        let acceptBtn = createButton(title: "View", color: .systemGreen, icon: "eye.fill")
        acceptBtn.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        
        stack.addArrangedSubview(declineBtn)
        stack.addArrangedSubview(acceptBtn)
        
        NSLayoutConstraint.activate([
            avatarContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            avatarContainer.widthAnchor.constraint(equalToConstant: 120),
            avatarContainer.heightAnchor.constraint(equalToConstant: 120),
            
            iconView.centerXAnchor.constraint(equalTo: avatarContainer.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: avatarContainer.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 120), // Match container
            iconView.heightAnchor.constraint(equalToConstant: 120),
            
            nameLabel.topAnchor.constraint(equalTo: avatarContainer.bottomAnchor, constant: 24),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            subLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            subLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            subLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            stack.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func createButton(title: String, color: UIColor, icon: String) -> UIButton {
        let btn = UIButton()
        btn.backgroundColor = color
        btn.layer.cornerRadius = 40
        let iconConfig = UIImage.SymbolConfiguration(pointSize: 30, weight: .bold)
        btn.setImage(UIImage(systemName: icon, withConfiguration: iconConfig), for: .normal)
        btn.tintColor = .white
        return btn
    }
    
    @objc func handleDismiss() {
        onDismiss?()
    }
}

// MARK: - Alarm Manager
class AlarmManager {
    var audioPlayer: AVAudioPlayer?
    
    func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(
                .playback,
                mode: .default,
                options: [.mixWithOthers, .duckOthers]
            )
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Audio setup error: \(error)")
        }
    }
    
    func playCustomSound(_ soundPath: String?, defaultName: String = "raid_alarm") {
        var finalUrl: URL?
        
        // 1. Try Custom Path
        if let path = soundPath, FileManager.default.fileExists(atPath: path) {
            finalUrl = URL(fileURLWithPath: path)
            print("🔊 Playing Custom Sound: \(path)")
        } else {
            // 2. Fallback to Bundle Resource
            let name = defaultName.components(separatedBy: ".").first ?? "alarm"
            let extensions = ["caf", "mp3", "wav", "m4a"]
            for ext in extensions {
                if let path = Bundle.main.url(forResource: name, withExtension: ext) {
                    finalUrl = path
                    break
                }
            }
            print("🔊 Playing Bundle Sound: \(defaultName)")
        }
        
        guard let soundUrl = finalUrl else { return }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundUrl)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.volume = 1.0
            audioPlayer?.play()
        } catch {
             print("❌ Audio Player Error: \(error)")
        }
    }
    
    func stopSound() {
        audioPlayer?.stop()
        audioPlayer = nil
    }
}

// MARK: - Settings Manager
class SettingsManager {
    static let shared = SettingsManager()
    private init() {} // Ensure singleton

    func getSQLiteAlarmSettings() -> [String: Any] {
        var settings: [String: Any] = [:]
        
        // Path to Documents/raidalarm.db
        guard let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return [:] }
        let dbPath = documentsPath.appendingPathComponent("raidalarm.db").path
        
        var db: OpaquePointer?
        if sqlite3_open(dbPath, &db) == SQLITE_OK {
            let query = "SELECT value FROM app_settings WHERE key = 'alarmSettings'"
            var statement: OpaquePointer?
            
            if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK {
                if sqlite3_step(statement) == SQLITE_ROW {
                    if let cString = sqlite3_column_text(statement, 0) {
                        let jsonString = String(cString: cString)
                        if let data = jsonString.data(using: .utf8) {
                            do {
                                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                    settings = json
                                }
                            } catch {
                                print("Error parsing SQLite JSON: \(error)")
                            }
                        }
                    }
                }
            }
            sqlite3_finalize(statement)
        }
        sqlite3_close(db)
        
        if settings.isEmpty {
             print("⚠️ No settings found in SQLite, using defaults.")
        } else {
             print("✅ Loaded Settings from SQLite: \(settings)")
        }
        
        return settings
    }
}
