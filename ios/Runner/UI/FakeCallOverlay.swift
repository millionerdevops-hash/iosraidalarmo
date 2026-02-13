import UIKit
import Foundation

// MARK: - Fake Call Overlay Manager
class FakeCallOverlay {
    private var overlayWindow: UIWindow?
    var onDismiss: (() -> Void)?
    
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
        onDismiss?() // Notify delegate (AppDelegate) to stop sound
        
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
