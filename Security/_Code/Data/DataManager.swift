//
//  DataManager.swift
//  Security
//
//  Created by Mike Lepore on 6/5/17.
//  Copyright © 2017 Ameropel. All rights reserved.
//

import UIKit
import Locksmith

class DataManager: NSObject {

    fileprivate let SavedSecureDataKey: String = "secureData"
    static let shared = DataManager()
    
    var secureDataArray: [SecureData] = [] {
        didSet {
           self.saveLocalData()
        }
    }
    
    override init()
    {
        super.init()
        self.loadLocalData()
    }
    
}

fileprivate extension DataManager {
    
    func loadLocalData() {
        
        guard let dataLoaded = Locksmith.loadDataForUserAccount(userAccount: SavedSecureDataKey) else { return }
        guard let dataArray = dataLoaded[SavedSecureDataKey] as? [[String: Any]] else { return }
        
        for data in dataArray {
            let json = JSON(data)
            self.secureDataArray.append(SecureData(withJSON: json))
        }
    }
    
    func saveLocalData() {
        
        var savedSecureData: [[String: Any]] = []
        for data in self.secureDataArray {
            savedSecureData.append(data.toJSONObject())
        }
 
        do {
            try Locksmith.updateData(data: [SavedSecureDataKey: savedSecureData], forUserAccount: SavedSecureDataKey)
        } catch {
            print("Error saving " + SavedSecureDataKey)
        }
    }
}
