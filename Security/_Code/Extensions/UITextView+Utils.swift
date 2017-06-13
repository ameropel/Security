//
//  UITextView+Utils.swift
//  Security
//
//  Created by Mike Lepore on 6/12/17.
//  Copyright © 2017 Ameropel. All rights reserved.
//

import UIKit

extension UITextView {
    
    func addClearButtonOnKeyboard(target: Any?, selector: Selector) {
        
        let clearToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        clearToolbar.barStyle = .blackTranslucent
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Clear", style: .done, target: target, action:selector)
        
        var items: [UIBarButtonItem] = []
        items.append(flexSpace)
        items.append(done)
        
        clearToolbar.items = items
        clearToolbar.sizeToFit()
        
        self.inputAccessoryView = clearToolbar
    }

    
}
