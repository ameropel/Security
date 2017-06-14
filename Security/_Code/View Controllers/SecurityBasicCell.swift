//
//  SecurityBasicCell.swift
//  Security
//
//  Created by Mike Lepore on 5/24/17.
//  Copyright © 2017 Ameropel. All rights reserved.
//

import UIKit
import MarqueeLabel

class SecurityBasicCell: UITableViewCell {

    // MARK: - Properties
    
    @IBOutlet weak var accountImage: UIImageView!
    @IBOutlet weak var accountName: UILabel!
    @IBOutlet weak var accountUsername: UILabel!
    @IBOutlet weak var accountPassword: UILabel!
    @IBOutlet weak var accountOther: MarqueeLabel!
    @IBOutlet weak var usernameTitle: UILabel!
    @IBOutlet weak var passwordTitle: UILabel!
    @IBOutlet weak var otherTitle: UILabel!
    @IBOutlet weak var otherTextContainer: UIView!
    @IBOutlet weak var otherHeightConstraint: NSLayoutConstraint!

    private var data: SecureData!
    private var togglePassword: Bool = false
    
    // MARK: - Cell Configuration
    
    func setCell(withData data: SecureData) {
        
        self.data = data
        
        self.configureUI()
        self.configureData()
    }
    
    
    // MARK: - UI
    
    private func configureUI() {
        self.contentView.backgroundColor = UIColor.secondaryColor
        
        // Titles
        self.accountName.textColor = UIColor.mainColor
        self.accountName.font = UIFont.verdana(size: 16)
        self.usernameTitle.setToTitleStyle()
        self.passwordTitle.setToTitleStyle()
        self.otherTitle.setToTitleStyle()
        
        // Data
        self.accountUsername.setToDataStyle()
        self.accountPassword.setToDataStyle()
        self.accountOther.setToDataStyle()

        
        // Image
        self.accountImage.layer.cornerRadius = 6.0
        self.accountImage.layer.masksToBounds = true
        self.accountImage.backgroundColor = UIColor.secondaryLightColor
        
        // Auto Scroll
        self.accountOther.type = .continuous
        self.accountOther.animationDelay = 2
        self.accountOther.animationCurve = .linear
        self.accountOther.trailingBuffer = 30.0
        
        self.togglePassword = false
    }
    
    
    // MARK: - Data
    
    private func configureData() {
        
        // Main data
        self.accountName.text = self.data.accountName
        self.accountUsername.text = self.data.username
        self.accountPassword.text = self.data.securePasswordFormat()
        
        // Other Data
        self.accountOther.text = self.data.otherTextFormat()
        self.otherTextContainer.isHidden = self.data.otherText.isEmpty
        self.otherHeightConstraint.constant = self.data.otherText.isEmpty ? 7 : 21
        
        // Image Data
        self.accountImage.image = nil
        if !self.data.image_url.isEmpty {

            guard let url = URL(string: self.data.image_url), UIApplication.shared.canOpenURL(url) else {
                return
            }
            
            self.accountImage.sd_setImage(with: url) { (image, error, cache, url) in
                if error != nil {
                    self.accountImage.image = nil
                    self.accountImage.backgroundColor = UIColor.secondaryLightColor
                } else {
                    self.accountImage.image = image
                    self.accountImage.backgroundColor = UIColor.clear
                }
            }
        }
    }
    
    
    // MARK: - Button Actions
    
    @IBAction func didPressPassword(_ sender: Any) {
        
        self.togglePassword = !self.togglePassword
        self.accountPassword.text = (self.togglePassword) ? data.password : data.securePasswordFormat()
    }
}


// MARK: - EXTENSIONS

fileprivate extension UILabel {
    
    func setToTitleStyle() {
        self.textColor = UIColor.white(withAlpha:0.7)
        self.font = UIFont.verdana(size: 12)
    }
    
    func setToDataStyle() {
        self.textColor = UIColor.mainColor
        self.font = UIFont.verdana(size: 12)
    }
}

