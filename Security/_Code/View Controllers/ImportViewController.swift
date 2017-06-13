//
//  ImportViewController.swift
//  Security
//
//  Created by Mike Lepore on 6/4/17.
//  Copyright © 2017 Ameropel. All rights reserved.
//

import UIKit

protocol ImportDelegate : class {
    func importAddedNewSecurityDetail(security: [SecureData])
    func importNewSecurityDetail(security: [SecureData])
}

class ImportViewController: UIViewController {
    
    private enum SegmentImportType : Int {
        case addData = 0
        case importData = 1
    }

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var statusLabel: StatusLabelView!
    @IBOutlet weak var dataImportTextView: UITextView!
    private var segmentType: SegmentImportType = .importData
    
    weak var delegate: ImportDelegate?
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }

    
    // MARK: - UI
    
    private func configureUI() {
        
        // Background
        self.view.backgroundColor = UIColor.clear
        self.view.addBlurView(blurStyle: .dark)
        
        // Close Button
        self.closeButton.setTitleColor(UIColor.mainColor, for: .normal)
        self.closeButton.titleLabel?.font = UIFont.navBarFont
        
        // Save Button
        self.saveButton.setTitleColor(UIColor.mainColor, for: .normal)
        self.saveButton.titleLabel?.font = UIFont.navBarFont

        // TextView
        self.dataImportTextView.layer.masksToBounds = true
        self.dataImportTextView.layer.cornerRadius = 6.0
        self.dataImportTextView.textColor = UIColor.white
        self.dataImportTextView.backgroundColor = UIColor.secondaryLightColor.withAlphaComponent(0.5)
        self.dataImportTextView.becomeFirstResponder()
        self.dataImportTextView.delegate = self
        self.dataImportTextView.addClearButtonOnKeyboard(target: self, selector: #selector(self.didPressTextViewClearButton))
    }
    
    
    // MARK: - Data Importing
    
    private func addData() {
        
        self.isDataValid { (data) in
            
            self.displayOkCancelAlert(title: "Add Data", message: "Are you sure you want to add data to your existing data?", actionOk: {
                
                self.statusLabel.showSuccessWithMessage(message: "Data added successfully")
                self.delegate?.importAddedNewSecurityDetail(security: data)
            }, actionCancel:{ })
        }
    }
    
    private func importData() {
        
        self.isDataValid { (data) in
        
            self.displayOkCancelAlert(title: "Import Data", message: "Are you sure you want to import new data? The pre-existing data will be overwritten.", actionOk: {
                    self.statusLabel.showSuccessWithMessage(message: "Data imported successfully")
                    self.delegate?.importNewSecurityDetail(security: data)
            }, actionCancel:{ })
        }
    }
    
    
    // MARK: - Data Validation 
    
    private func isDataValid(onSuccess: ([SecureData]) -> Void) {
        
        SecureData.isDataValid(dataString: self.dataImportTextView.text, onSuccess: { (data) in
          onSuccess(data)
        }, onError: { (error) in
            self.statusLabel.showErrorWithMessage(message: error)
        })
    }
    
    
    // MARK: - Buttons
    
    @IBAction func didPressCloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didPressSaveButton(_ sender: Any) {
        
        let segmentValue:SegmentImportType = ImportViewController.SegmentImportType(rawValue: self.segmentController.selectedSegmentIndex)!
        
        if segmentValue == .addData {
            self.addData()
        } else if segmentValue == .importData {
            self.importData()
        }
    }
    
    @IBAction func didPressInfoButton(_ sender: Any) {
        let infoView = ImportInfoViewController()
        infoView.modalPresentationStyle = .custom
        self.present(infoView, animated: false, completion: nil)
    }
    
    
    // MARK: - Keyboard Additions
    
    func didPressTextViewClearButton() {
        self.dataImportTextView.text = ""
    }
}


// MARK: - EXTENSIONS

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

extension ImportViewController : UITextViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let verticalIndicator = scrollView.subviews.last as? UIImageView
        verticalIndicator?.backgroundColor = UIColor.mainColor
    }
}
