//
//  SecureData.swift
//  Security
//
//  Created by Mike Lepore on 5/24/17.
//  Copyright © 2017 Ameropel. All rights reserved.
//

import UIKit

class SecureData: NSObject {
    
    var id: String!
    var accountName: String!
    var username: String!
    var password: String!
    var otherText: String!
    var image_url: String!
    
    // MARK: - Initializer
    
    init(accountName: String, username: String, password: String, otherText: String, imageUrl: String) {
        
        super.init()
        
        self.id = self.setTimeStamp()
        self.accountName = accountName.isEmpty ? "" : accountName
        self.username = username.isEmpty ? "" : username
        self.password = password.isEmpty ? "" : password
        self.otherText = otherText.isEmpty ? "" : otherText
        self.image_url = imageUrl.isEmpty ? "" : otherText
    }
    
    init(withJSON json: JSON) {
        
        super.init()
        
        self.id = self.setTimeStamp()
        self.accountName = json["accountName"].stringValue
        self.username = json["username"].stringValue
        self.password = json["password"].stringValue
        self.otherText = json["otherText"].stringValue
        self.image_url = json["image_url"].stringValue
    }
    
    
    // MARK: - JSON Methods
    
    func toJSONObject() -> [String: Any] {
        return [
            "accountName": self.accountName,
            "username": self.username,
            "password": self.password,
            "otherText": self.otherText,
            "image_url": self.image_url
        ]
    }
    
    func toJSONString() -> String {

        var jsonString: String = ""
        jsonString.append("{\n")
        jsonString.append(String(format:"    \"accountName\" : \"%@\"\n", self.accountName))
        jsonString.append(String(format:"    \"username\" : \"%@\"\n", self.username))
        jsonString.append(String(format:"    \"password\" : \"%@\"\n", self.password))
        jsonString.append(String(format:"    \"image_url\" : \"%@\"\n", self.otherText))
        jsonString.append(String(format:"    \"otherText\" : \"%@\"\n", self.image_url))
        jsonString.append("}")

        return jsonString
    }
    
    
    // MARK: - Other Methods
    
    static func containsValidData(json: JSON) -> Bool {
        
        let accountName = json["accountName"].stringValue
        let username = json["username"].stringValue
        let password = json["password"].stringValue
        
        return (!accountName.isEmpty &&
                !username.isEmpty &&
                !password.isEmpty)
    }
    
    
    // MARK: - Formatters
    
    private func setTimeStamp() -> String {
        
        let time = Date().timeIntervalSinceReferenceDate
        return String(time)
    }
    
    func securePasswordFormat() -> String {
        
        let pwdCount = self.password.characters.count
        var secureFormat: String = ""

        for _ in 0...pwdCount-1 {
            secureFormat.append("*")
        }

        return secureFormat
    }
    
    func otherTextFormat() -> String {
        return self.otherText.replacingOccurrences(of: "\n", with: " - ")
    }
}
