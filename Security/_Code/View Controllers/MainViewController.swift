//
//  MainViewController.swift
//  Security
//
//  Created by Mike Lepore on 5/24/17.
//  Copyright © 2017 Ameropel. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var topDividerView: UIView!
    @IBOutlet weak var tableContainer: UIView!
    @IBOutlet weak var addButton: UIButton!
    
    lazy fileprivate(set) var tableView: SecurityTable! = {
        var controller = SecurityTable(nibName: "SecurityTable", bundle: nil)
        controller.delegate = self
        return controller
    }()

    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {

        super.viewDidLoad()
        self.configureUI()
        self.configureNavBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if (self.tableView != nil) {
            self.tableView.view.frame = self.tableContainer.bounds
        }
    }
    
    
    // MARK: - UI
    
    private func configureNavBar() {
        // Settings
        let leftBarItem: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(didPressImportButton))
        self.navigationController?.navigationItem.setLeftBarButton(leftBarItem, animated: true)
        self.navigationItem.leftBarButtonItem = leftBarItem
        
        // Export
        let rightBarItem: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didPressExportButton))
        self.navigationController?.navigationItem.setRightBarButton(rightBarItem, animated: true)
        self.navigationItem.rightBarButtonItem = rightBarItem
    }
    
    private func configureUI() {
        
        // Divider
        self.topDividerView.backgroundColor = UIColor.mainColor
        
        // Setup Table
        self.tableView.view.backgroundColor = UIColor.secondaryColor
        self.tableView.view.frame = self.tableContainer.bounds
        self.tableContainer.addSubview(self.tableView.view)
        
        let data = DataManager.shared.secureDataArray
        self.tableView.refreshTable(withData: data)
        
        // Add Button
        self.addButton.titleLabel?.font = UIFont.verdana(size: 16)
        self.addButton.setTitleColor(UIColor.white, for: .normal)
        self.addButton.backgroundColor = UIColor.mainColor
    }
    
    
    // MARK: - Buttons
    
    @objc private func didPressImportButton() {
        let importView = ImportViewController()
        importView.delegate = self
        importView.modalPresentationStyle = .custom
        self.present(importView, animated: true, completion: nil)
    }
    
    @objc private func didPressExportButton() {
        
        guard DataManager.shared.secureDataArray.count > 0 else {
            
            self.displaySimpleAlert(title: "Export", message: "There is no data to export")
            return
        }
        
        let exportData = ExportData()
        exportData.exportData(from: self)
    }
    
    @IBAction func didPressAddButton(_ sender: Any) {
        let securityView = SecurityDetailViewController()
        securityView.modalPresentationStyle = .custom
        securityView.delegate = self
        
        self.present(securityView, animated: true, completion: nil)
    }
}


// MARK: - EXTENSIONS

extension MainViewController : SecurityDetailDelegate {
    
    func addedNewSecurityDetail(security: SecureData) {
        self.tableView.addNewData(data: [security])
    }
    
    func editedSecurityDetail(security: SecureData) {
        self.tableView.updateData(data: security)
    }
}

extension MainViewController : ImportDelegate {
    
    func importAddedNewSecurityDetail(security: [SecureData]) {
        self.tableView.addNewData(data: security)
    }
    
    func importNewSecurityDetail(security: [SecureData]) {
        self.tableView.refreshTable(withData: security)
    }
}

extension MainViewController : SecurityTableDelegate {
    
    func editSecureData(data: SecureData) {
        let securityView = SecurityDetailViewController(secureData: data)
        securityView.modalPresentationStyle = .custom
        securityView.delegate = self
        self.present(securityView, animated: true, completion: nil)
    }
}
