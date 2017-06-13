//
//  ImportInfoViewController.swift
//  Security
//
//  Created by Mike Lepore on 6/12/17.
//  Copyright © 2017 Ameropel. All rights reserved.
//

import UIKit

class ImportInfoViewController: UIViewController {
    
    @IBOutlet weak var backgroudView: UIView!
    @IBOutlet weak var alertContainer: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var alertTitle: UILabel!
    @IBOutlet weak var dataTextField: UITextView!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.backgroudView.backgroundColor = .clear
        self.backgroudView.addBlurView(blurStyle: .dark)
        
        self.animateIn()
    }
    
    
    // MARK: - UI
    
    private func configureUI() {

        self.view.backgroundColor = .clear
        
        // Main Container
        self.alertContainer.backgroundColor = UIColor.secondaryColor
        self.alertContainer.layer.masksToBounds = true
        self.alertContainer.layer.cornerRadius = 6.0
        self.alertContainer.layer.borderWidth = 1.0
        self.alertContainer.layer.borderColor = UIColor.mainColor.cgColor
        
        // Title
        self.alertTitle.font = UIFont.verdana(size: 18)
        self.alertTitle.textColor = UIColor.mainColor
        
        // Button
        self.closeButton.titleLabel?.font = UIFont.verdana(size: 18)
        self.closeButton.setTitleColor(UIColor.white, for: .normal)
        
        // Text Field
        self.dataTextField.layer.masksToBounds = true
        self.dataTextField.layer.cornerRadius = 6
        self.dataTextField.tintColor = UIColor.mainColor
        self.dataTextField.textColor = UIColor.white(withAlpha: 0.7)
        self.dataTextField.font = UIFont.verdana(size: 10)
        self.dataTextField.backgroundColor = UIColor.secondaryLightColor.withAlphaComponent(0.5)
        self.dataTextField.text = SecureData.JSONExample()
    }
    
    
    // MARK: - Transitions
    
    private func animateIn() {
        
        DispatchQueue.main.async {
            self.backgroudView.alpha = 0
            
            UIView.animate(withDuration: 0.25, delay:0, options: [.curveEaseIn], animations: {
                self.backgroudView.alpha = 0.8
            }, completion: nil)
            
            self.alertContainer.alpha = 0
            UIView.animate(withDuration: 0.25, delay:0.25, options: [.curveEaseIn], animations: {
                self.alertContainer.alpha = 1.0
            }, completion: nil)
        }
    }
    
    private func animateOut() {
    
        DispatchQueue.main.async {

            UIView.animate(withDuration: 0.25, delay:0, options: [.curveEaseIn], animations: {
                self.backgroudView.alpha = 0
                self.alertContainer.alpha = 0.0
            }, completion: { (complete) in
                self.dismiss(animated: false, completion: nil)
            })
        }
    }
    
    
    // MARK: - Buttons
    
    @IBAction func didPressCloseButton(_ sender: Any) {
        self.animateOut()
    }
}
