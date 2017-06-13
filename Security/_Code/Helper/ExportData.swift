//
//  ExportData.swift
//  Security
//
//  Created by Mike Lepore on 6/11/17.
//  Copyright © 2017 Ameropel. All rights reserved.
//

import UIKit
import MessageUI
import Zip

class ExportData : NSObject {
    
    private var displayView: UIViewController!
    private var zipFileURL: URL!
    
    func exportData(from view: UIViewController) {
    
        self.displayView = view
        
        /*
        guard MFMailComposeViewController.canSendMail() else {
            
            self.displayView.displaySimpleAlert(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.")
            return
        }
        
        
        let fileData: Data = Data()
        let mailComposeViewController =  self.configuredMailComposeViewController(withAttatchment: fileData)
        self.displayView.present(mailComposeViewController, animated: true, completion: nil)
         */
        //self.displayPasswordAlert { (password) in
        
        
            self.zipData(data: self.dataToImport(), withPassword: "password", onSuccess: { (url) in
                
                self.zipFileURL = url
                
                let fileData = NSData(contentsOf: url)
                //let mailComposeViewController =  self.configuredMailComposeViewController(withAttatchment: fileData! as Data)
                //self.displayView.present(mailComposeViewController, animated: true, completion: nil)
                
            }, onError: { (error) in
                self.displayView.displaySimpleAlert(title: "Export Error", message: error)
            })
        //}
    }
    
    
    // MARK: - Password Alert
    
    private func displayPasswordAlert(onSuccess: @escaping (String) -> Void) {
        
        let alertController = UIAlertController(title: "Export Data", message: "Enter a password to encrypt data", preferredStyle: .alert)
        
        let passwordAction = UIAlertAction(title: "Export", style: .default, handler: {
            alert -> Void in
            let password = alertController.textFields![0] as UITextField
            onSuccess(password.text!)
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "password"
        }
        
        alertController.addAction(passwordAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler:nil))
        
        self.displayView.present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: - Data to Import
    
    private func dataToImport() -> String {
        
        let count:Int = DataManager.shared.secureDataArray.count
        var index:Int = 0
        
        
        var secureDataString: String = "{\n    \"data\" : [\n"
        for data in DataManager.shared.secureDataArray {
            
            index += 1
            
            secureDataString.append("    {\n")
            secureDataString.append(String(format: "          \"accountName\" : \"%@\",\n", data.accountName))
            secureDataString.append(String(format: "          \"username\" : \"%@\",\n", data.username))
            secureDataString.append(String(format: "          \"password\" : \"%@\",\n", data.password))
            secureDataString.append(String(format: "          \"image_url\" : \"%@\",\n", data.image_url))
            secureDataString.append(String(format: "          \"otherText\" : \"%@\"\n", data.otherText))
            secureDataString.append("    }")
            
            if index < count {
                secureDataString.append(",\n")
            }
        }
        secureDataString.append("]\n}")
        
        
        /*
        var secureDataString: String = "{data : ["
        for data in DataManager.shared.secureDataArray {
            
            index += 1
            
            secureDataString.append(String(format: "          \"accountName\" : \"%@\"\n", data.accountName))
            secureDataString.append(String(format: "          \"username\" : \"%@\"\n", data.username))
            secureDataString.append(String(format: "          \"password\" : \"%@\"\n", data.password))
            secureDataString.append(String(format: "          \"image_url\" : \"%@\"\n", data.image_url))
            secureDataString.append(String(format: "          \"otherText\" : \"%@\"\n", data.otherText))
            secureDataString.append("    }")
            
            if index < count {
                secureDataString.append(",\n")
            }
        }
        secureDataString.append("]\n}")
         */
        
        return secureDataString
    }


    // MARK: - Email
    
    private func configuredMailComposeViewController(withAttatchment attachment: Data) -> MFMailComposeViewController {
        
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setSubject("Secure Data")
        mailComposerVC.setMessageBody("Sending e-mail in-app is not so bad!", isHTML: false)
        //mailComposerVC.addAttachmentData(attachment, mimeType: "application/zip", fileName: "SecureData.zip")
        
        return mailComposerVC
    }

}

// MARK: - File Management

fileprivate extension ExportData {
    
     func zipData(data: String, withPassword password: String, onSuccess: @escaping (URL) -> Void, onError: (String) -> Void) {
        
        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            onError("Couldn't create directory")
            return
        }
        
        // Writing
        let filePath = dir.appendingPathComponent("data.json")
        do {
            
            // File written
            try data.write(to: filePath, atomically: false, encoding: String.Encoding.utf8)
            
            /*
             case NoCompression
             case BestSpeed
             case DefaultCompression
             case BestCompression
             */
            
            
            
            
            //  Zip File
            let zipFilePath = dir.appendingPathComponent("archive.zip")
            try Zip.zipFiles(paths: [filePath], zipFilePath: zipFilePath, password: password, compression: .BestCompression, progress: { (progress) -> () in
                print("Zip Progress: ", progress)
                
            }, onSucess: {
                // Remove original file created
                remove(filePath: filePath)
                
                // Send zip on completion
                onSuccess(zipFilePath)
            })
        }
        catch {
            onError("Failure creating file to path")
        }
        
    }

    func remove(filePath: URL) {
        
        do {
            try FileManager.default.removeItem(at: filePath)
        } catch let error as NSError {
            print("Error: \(error.domain)")
        }
    }
    
}

extension ExportData : MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        
        
        
    }
}

