//
//  SecurityTable.swift
//  Security
//
//  Created by Mike Lepore on 5/24/17.
//  Copyright © 2017 Ameropel. All rights reserved.
//

import UIKit
import SwipeCellKit

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
        self.sortDataAlphabetically()
        self.tableView.reloadData()
        
        DataManager.shared.secureDataArray = self.tableData
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
        cell.delegate = self
        
        return cell
    }
}


// MARK: - EXTENSIONS

extension SecurityTable : SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        if orientation == .right {
            
            let deleteAction = SwipeAction(style: .default, title: "Delete") { action, indexPath in
                self.tableData.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                DataManager.shared.secureDataArray = self.tableData
            }
            let image = UIImage(named: "remove-icon")?.scaleToSize(size: CGSize(width: 30, height: 30))
            deleteAction.image = image
            deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.2352941176, blue: 0.1882352941, alpha: 1)
            return [deleteAction]
            
        } else {
            
            let editAction = SwipeAction(style: .default, title: "Edit") { action, indexPath in
                self.delegate?.editSecureData(data: self.tableData[(indexPath as NSIndexPath).row])
            }
            let image = UIImage(named: "editing-icon")?.scaleToSize(size: CGSize(width: 30, height: 30))
            editAction.image = image
            editAction.backgroundColor = UIColor.mainColor
            return [editAction]
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        
        var options = SwipeTableOptions()
        options.expansionStyle = .selection
        options.transitionStyle = .reveal
        
        switch orientation {
        case .left:
            options.buttonPadding = 15
            options.backgroundColor = UIColor.mainColor
            
        case .right:
            options.buttonPadding = 15
            options.backgroundColor = #colorLiteral(red: 1, green: 0.2352941176, blue: 0.1882352941, alpha: 1)
        }
        
        return options
    }
}
