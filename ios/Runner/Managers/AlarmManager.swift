import Foundation
import AVFoundation
import AudioToolbox

class AlarmManager {
    var audioPlayer: AVAudioPlayer?
    var vibrationTimer: Timer?
    var durationTimer: Timer?
    
    // Callback to notify when alarm stops (manually or by timer)
    var onStop: (() -> Void)?
    
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
    
    func playCustomSound(_ soundPath: String?, defaultName: String = "raid_alarm", vibrate: Bool = true, duration: Double = 30, loop: Bool = true) {
        // Stop any previous playing sound/vibration
        stopSound()
        
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
        
        // Play Audio
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundUrl)
            // Always loop (-1) because alarm sounds are short and must fill duration (or infinite)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.volume = 1.0
            audioPlayer?.play()
        } catch {
             print("❌ Audio Player Error: \(error)")
        }
        
        // Vibrate
        if vibrate {
            startVibration()
        }
        
        // Auto Stop Duration
        // Logic:
        // - If infiniteLoop (loop) is TRUE: Run forever (No Timer).
        // - If infiniteLoop (loop) is FALSE: Stop after 'duration' seconds.
        if !loop && duration > 0 {
            print("⏳ Alarm will stop automatically in \(duration) seconds.")
            durationTimer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { [weak self] _ in
                print("🛑 Alarm Duration Reached. Stopping.")
                self?.stopSound()
            }
        }
    }
    
    private func startVibration() {
        // Vibrate immediately
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        
        // Loop vibration every 1 second
        vibrationTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        }
    }
    
    func stopSound() {
        // Stop Audio
        if audioPlayer?.isPlaying == true {
            audioPlayer?.stop()
        }
        audioPlayer = nil
        
        // Stop Vibration
        vibrationTimer?.invalidate()
        vibrationTimer = nil
        
        // Cancel Duration Timer
        durationTimer?.invalidate()
        durationTimer = nil
        
        // Notify listener
        onStop?()
    }
}
