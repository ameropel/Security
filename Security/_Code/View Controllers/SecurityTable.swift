//
//  SecurityTable.swift
//  Security
//
//  Created by Mike Lepore on 5/24/17.
//  Copyright © 2017 Ameropel. All rights reserved.
//

import UIKit

protocol SecurityTableDelegate : class {
    func editSecureData(data: SecureData)
}

class SecurityTable: UITableViewController {
    
    fileprivate var tableData: [SecureData] = []
    weak var delegate: SecurityTableDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 58
        
        self.tableView.delegate   = self;
        self.tableView.dataSource = self;
        
        // Remove empty cells dividers
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorColor = UIColor.mainColor
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        
        // Configure Cells
        self.tableView.register(UINib(nibName: "SecurityBasicCell", bundle: nil), forCellReuseIdentifier: "SecurityBasicCell")
    }
    
    
    // MARK: - Helpers
    
    func refreshTable(withData data: [SecureData]) {
        
        self.tableData.removeAll()
        self.tableData.append(contentsOf: data)
        self.sortDataAlphabetically()
        self.tableView.reloadData()
        
        DataManager.shared.secureDataArray = self.tableData
        
        // Hide table if there is no data
        self.view.isHidden = tableData.count == 0 ? true : false
    }

    func addNewData(data: [SecureData]) {
        
        self.tableData.append(contentsOf: data)
        self.refreshTable(withData: self.tableData)
    }
    
    func updateData(data: SecureData) {
        
        for secureData in self.tableData {
            if secureData.id == data.id {
                self.tableData.remove(at: self.tableData.index(of: secureData)!)
                self.addNewData(data: [data])
                break
            }
        }
    }
    
    private func sortDataAlphabetically() {
        let sortedArray: [SecureData] = self.tableData.sorted { $0.accountName < $1.accountName }
        self.tableData = sortedArray
    }
    
    
    // MARK: - UIScrollViewDelegate
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let verticalIndicator = scrollView.subviews.last as? UIImageView
        verticalIndicator?.backgroundColor = UIColor.mainColor
    }
    
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SecurityBasicCell", for: indexPath) as! SecurityBasicCell
        
        let secureData = self.tableData[(indexPath as NSIndexPath).row]
        cell.setCell(withData: secureData)
        cell.selectionStyle = .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        
        let edit = UITableViewRowAction(style: .normal, title: "  Edit  ") { action, index in
            self.delegate?.editSecureData(data: self.tableData[(editActionsForRowAt as NSIndexPath).row])
        }
        edit.backgroundColor = UIColor.mainColor
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            
            self.displayOkCancelAlert(title: "Wait", message: "Are you sure you want to delete this password?", actionOk: { 
                self.tableData.remove(at: editActionsForRowAt.row)
                self.tableView.deleteRows(at: [editActionsForRowAt], with: .fade)
                DataManager.shared.secureDataArray = self.tableData
            }, actionCancel: {})
        }
        delete.backgroundColor = UIColor.tomato
        
        return [delete, edit]
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}
