//
//  SecureLoginViewController.swift
//  Security
//
//  Created by Mike Lepore on 5/26/17.
//  Copyright © 2017 Ameropel. All rights reserved.
//

import UIKit
import LocalAuthentication

class SecureLoginViewController: UIViewController {

    @IBOutlet weak var touchIDContainer: UIView!
    @IBOutlet weak var unlockButton: UIButton!
    @IBOutlet weak var unlockLabel: UILabel!
    @IBOutlet weak var statusLabel: StatusLabelView!
    var context = LAContext()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fadeInTransition()
    }
    
    
    // MARK: - UI
    
    private func configureUI() {
        
        self.view.backgroundColor = .clear
        self.view.addBlurView(blurStyle: .dark)
        
        self.unlockButton.backgroundColor = .clear
        
        self.unlockLabel.font = UIFont.verdana(size: 20)
        self.unlockLabel.textColor = UIColor.mainColor
    }

    
    // MARK: - Transitions
    
    private func fadeInTransition() {

        DispatchQueue.main.async {
            
            self.touchIDContainer.alpha = 0
            UIView.animate(withDuration: 0.25, delay:1.0, options: [.curveEaseIn], animations: {
                self.touchIDContainer.alpha = 1
            }, completion: nil)
        }
    }
    
    private func dismissTransition() {
        
        DispatchQueue.main.async {
    
            self.view.alpha = 1
            UIView.animate(withDuration: 0.5, delay: 0.2, options: [.curveEaseOut], animations: {
                self.view.alpha = 0
            }) { (complete) in
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    
    // MARK: - Touch ID
    
    private func touchID() {
                
        // iOS Simulator does not support touch ID. Just sign in
        guard !Platform.isSimulator else {
            self.dismissTransition()
            return
        }
        
        // If the device does not support touch ID
        guard self.context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error:nil) else {
            self.statusLabel.showErrorWithMessage(message: "Touch ID not available")
            return
        }
        
        self.context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Unlock with Touch ID") { (success, error ) in
            
            guard !success else {
                self.dismissTransition()
                return
            }
            
            if error != nil {
                let error = error! as NSError
                
                switch(error.code) {
                    
                case LAError.authenticationFailed.rawValue:
                    self.statusLabel.showErrorWithMessage(message: "There was a problem verifying your identity.")
                    break
                case LAError.userCancel.rawValue:
                    self.statusLabel.showErrorWithMessage(message: "You pressed cancel.")
                    break
                case LAError.userFallback.rawValue:
                    self.statusLabel.showErrorWithMessage(message: "You pressed password.")
                    break
                default:
                    self.statusLabel.showErrorWithMessage(message: "Touch ID may not be configured")
                    break
                }
            }
        }
    }

    
    // MARK: - Buttons
    
    @IBAction func didPressTouchIDLoginButton(_ sender: Any) {
        self.touchID()
    }
}
