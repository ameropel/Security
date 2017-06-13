//
//  UIViewController+Utils.swift
//  Security
//
//  Created by Mike Lepore on 6/3/17.
//  Copyright © 2017 Ameropel. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func displaySimpleAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func displayOkCancelAlert(title: String, message: String, actionOk: @escaping () -> Void, actionCancel: @escaping () -> Void) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            actionOk()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
            actionCancel()
        }
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
}
