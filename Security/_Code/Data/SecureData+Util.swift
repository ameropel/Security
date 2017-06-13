//
//  SecureData+Util.swift
//  Security
//
//  Created by Mike Lepore on 6/12/17.
//  Copyright © 2017 Ameropel. All rights reserved.
//

import UIKit


extension SecureData {
    
    // MARK: - Data Validation
    
    static func isDataValid(dataString: String?, onSuccess:([SecureData]) -> Void, onError: (String) -> Void) {
        
        // No text provided
        guard let text = dataString, !text.isEmpty  else {
            onError("There is no data to add or import")
            return
        }
        
        // Not proper json format
        let jsonObj = JSON(parseJSON: text)
        guard jsonObj != JSON.null  else {
            onError("Input not in proper JSON format")
            return
        }
        
        SecureData.convertJSONToData(jsonObj: jsonObj, onCompletion: onSuccess, onError: onError)
    }
    
    static func convertJSONToData(jsonObj: JSON, onCompletion:([SecureData]) -> Void, onError: (String) -> Void) {
        
        // Data is not valid at all
        guard jsonObj.count > 0 else {
            onError("JSON did not provide any data")
            return
        }
        
        let arrayOfJson = jsonObj["data"].arrayValue
        
        // Data is in form of dictionary but not in an array
        guard arrayOfJson.count > 0 else  {
            if SecureData.containsValidData(json: jsonObj) {
                onCompletion([SecureData(withJSON: jsonObj)])
            } else {
                onError("JSON is not formatted properly. Make sure data contains proper keys and values.")
            }
            return
        }
        
        // We have an array of dicitionaries
        var secureDataArray: [SecureData] = []
        var invalidDataCount:Int = 0
        for data in arrayOfJson {
            
            if SecureData.containsValidData(json: data) {
                let secureData = SecureData(withJSON: data)
                secureDataArray.append(secureData)
            } else {
                invalidDataCount += 1
            }
        }
        
        // All data in array was incorrect
        guard secureDataArray.count > 0 else {
            onError("Array of data does not contain any valid secure data. Make sure data contains proper keys and values.")
            return
        }
        
        if invalidDataCount == 0 {
            onCompletion(secureDataArray)
        } else {
            onError("Array of data contains some invalid secure data. Make sure data contains proper keys and values.")
        }
    }

    
    // MARK: - Data Example
    
    static func JSONExample() -> String {
        
        // I know \t exists but the spacing is a little too much
        var example: String = ""
        example.append("{\n")
        example.append("    \"data\" :\n")
        example.append("    [ {\n")
        example.append("          \"accountName\" : \"account_name\",\n")
        example.append("          \"username\" : \"login_name\",\n")
        example.append("          \"password\" : \"login_password\",\n")
        example.append("          \"image_url\" : \"image_url\",\n")
        example.append("          \"otherText\" : \"other information\"\n")
        example.append("    } ]\n")
        example.append("}")
        
        return example
        
    }
    
}
