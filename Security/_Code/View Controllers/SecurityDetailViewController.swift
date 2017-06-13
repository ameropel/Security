//
//  SecurityDetailViewController.swift
//  Security
//
//  Created by Mike Lepore on 5/26/17.
//  Copyright © 2017 Ameropel. All rights reserved.
//

import UIKit
import SDWebImage

protocol SecurityDetailDelegate : class {
    func addedNewSecurityDetail(security: SecureData)
    func editedSecurityDetail(security: SecureData)
}

class SecurityDetailViewController: UIViewController {

    @IBOutlet weak var detailsContainer: UIView!
    @IBOutlet weak var accountNameTitle: UILabel!
    @IBOutlet weak var usernameTitle: UILabel!
    @IBOutlet weak var passwordTitle: UILabel!
    @IBOutlet weak var otherInfoTitle: UILabel!
    @IBOutlet weak var uploadImageTitle: UILabel!
    @IBOutlet weak var accountNameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var imageTextField: UITextField!
    @IBOutlet weak var otherTextTextView: UITextView!
    @IBOutlet weak var defaultAccountImage: UIImageView!
    @IBOutlet weak var accountImageView: UIImageView!
    @IBOutlet weak var statusLabel: StatusLabelView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    private var secureData: SecureData?
    weak var delegate: SecurityDetailDelegate?
    
    
    // MARK: - Initializer
    
    convenience init() {
        self.init(secureData: nil)
    }
    
    init(secureData: SecureData?) {
        self.secureData = secureData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

 
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.configureSecureData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
         self.view.endEditing(true)
    }
    
    
    // MARK: - UI
    
    private func configureUI() {
        
        // Background
        self.view.backgroundColor = .clear
        self.view.addBlurView(blurStyle: .dark)
    
        // Container
        self.detailsContainer.backgroundColor = UIColor.clear
        self.detailsContainer.layer.cornerRadius = 6
        self.detailsContainer.layer.masksToBounds = true
        
        // Image View
        self.defaultAccountImage.image = self.defaultAccountImage.image?.maskWithColor(color: UIColor.mainColor)
        self.accountImageView.layer.borderColor = UIColor.mainColor.cgColor
        self.accountImageView.layer.borderWidth = 2
        self.accountImageView.layer.cornerRadius = 6
        self.accountImageView.layer.masksToBounds = true
        
        // Titles
        self.accountNameTitle.setToTitleStyle(size: 14)
        self.usernameTitle.setToTitleStyle(size: 14)
        self.passwordTitle.setToTitleStyle(size: 14)
        self.otherInfoTitle.setToTitleStyle(size: 14)
        self.uploadImageTitle.setToTitleStyle(size: 14)
        
        // Text Input Fields
        self.accountNameTextField.delegate = self
        self.accountNameTextField.setToInputStyle()
        self.accountNameTextField.becomeFirstResponder()
        
        self.usernameTextField.delegate = self
        self.usernameTextField.setToInputStyle()
        
        self.passwordTextField.delegate = self
        self.passwordTextField.setToInputStyle()
        
        self.imageTextField.delegate = self
        self.imageTextField.setToInputStyle()
        
        self.otherTextTextView.setToInputStyle()
        
        // Button
        self.cancelButton.setTitleColor(UIColor.mainColor, for: .normal)
        self.cancelButton.titleLabel?.font = UIFont.navBarFont
        
        self.saveButton.setTitleColor(UIColor.mainColor, for: .normal)
        self.saveButton.titleLabel?.font = UIFont.navBarFont
    }
    
    private func configureSecureData() {
        
        guard let data = self.secureData else {
            return
        }

        // If we have data, populate information
        self.accountNameTextField.text = data.accountName
        self.usernameTextField.text = data.username
        self.passwordTextField.text = data.password
        self.imageTextField.text = data.image_url
        self.otherTextTextView.text = data.otherText
        
        self.loadImage()
    }
    
    
    // MARK: - Validation
    
    private func isDataValidToSave() -> Bool {
        
        // Account name
        if let text = self.accountNameTextField.text, !text.isEmpty {
            
            if text.characters.count < 2 {
                self.statusLabel.showErrorWithMessage(message: "Account name must be at least 3 characters long")
                return false
            }
            
        } else {
            self.statusLabel.showErrorWithMessage(message: "Must include an account name")
            return false
        }
        
        // Username
        if let text = self.usernameTextField.text, text.isEmpty {
            self.statusLabel.showErrorWithMessage(message: "Must include a username")
            return false
        }
        
        // Password
        if let text = self.passwordTextField.text, text.isEmpty {
            self.statusLabel.showErrorWithMessage(message: "Must include a password")
            return false
        }
        
        return true
    }
    
    
    // MARK: - Image Processing
    
    func loadImage() {
        
        guard let urlString = self.imageTextField.text, !urlString.isEmpty else { return }
        guard let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) else {
            
            self.statusLabel.showErrorWithMessage(message: "Url can not be opened")
            return
        }
        
        self.accountImageView.sd_setImage(with: url) { (image, error, cache, url) in
            if error != nil {
                self.accountImageView.layer.borderWidth = 2
                self.accountImageView.image = nil
                self.statusLabel.showErrorWithMessage(message: "Error trying to fetch image")
            } else {
                self.accountImageView.layer.borderWidth = 0
                self.accountImageView.image = image
            }

        }
    }
    
    
    // MARK: - Nav Bar Buttons
    
    @IBAction func didPressSaveButton(_ sender: Any) {
        
        if self.isDataValidToSave() {
            
            guard let accountName = self.accountNameTextField.text,
                let username = self.usernameTextField.text,
                let password = self.passwordTextField.text,
                let otherText = self.otherTextTextView.text,
                let imageUrl  = self.imageTextField.text else {
                    self.statusLabel.showErrorWithMessage(message: "Data provided is not valid. Missing some parameters")
                    return
            }
            
            // Editing data
            if let data = self.secureData {
                
                data.accountName = accountName
                data.username = username
                data.password = password
                data.otherText = otherText
                data.image_url = imageUrl
                
                self.delegate?.editedSecurityDetail(security: data)
            } else {
                // Creating new data
                let data = SecureData(accountName: accountName, username: username, password: password, otherText: otherText, imageUrl: imageUrl)
                self.delegate?.addedNewSecurityDetail(security: data)
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func didPressCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}


// MARK: - EXTENSIONS

extension SecurityDetailViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.accountNameTextField {
            self.usernameTextField.becomeFirstResponder()
        } else if textField == self.usernameTextField {
            self.passwordTextField.becomeFirstResponder()
        } else if textField == self.passwordTextField {
            self.imageTextField.becomeFirstResponder()
        } else if textField == self.imageTextField {
            self.loadImage()
            self.otherTextTextView.becomeFirstResponder()
            return false
        }
        
        return true
    }
}

fileprivate extension UILabel {
    
    func setToTitleStyle(size: CGFloat) {
        self.textColor = UIColor.white.withAlphaComponent(0.7)
        self.font = UIFont.verdana(size: size)
    }
}

fileprivate extension UITextField {
    
    func setToInputStyle() {
        self.tintColor = UIColor.mainColor
        self.textColor = UIColor.white.withAlphaComponent(0.7)
        self.font = UIFont.verdana(size: 14)
        self.backgroundColor = UIColor.secondaryLightColor.withAlphaComponent(0.5)
    }
}

fileprivate extension UITextView {
    
    func setToInputStyle() {
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 6
        self.tintColor = UIColor.mainColor
        self.textColor = UIColor.white.withAlphaComponent(0.7)
        self.font = UIFont.verdana(size: 14)
        self.backgroundColor = UIColor.secondaryLightColor.withAlphaComponent(0.5)
    }
}
