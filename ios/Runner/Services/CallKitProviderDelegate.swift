import CallKit
import UIKit
import Foundation

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
