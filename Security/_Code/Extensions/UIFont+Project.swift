//
//  UIFont+Project.swift
//  Security
//
//  Created by Mike Lepore on 6/1/17.
//  Copyright © 2017 Ameropel. All rights reserved.
//

import UIKit

extension UIFont {
    
    class var navBarFont: UIFont {
        return self.verdana(size: 15)
    }
    
    static func verdana(size: CGFloat) -> UIFont {
        return font(name: "Verdana", size: size)
    }
    
    static func verdanaItalic(size: CGFloat) -> UIFont {
        return font(name: "Verdana-Italic", size: size)
    }
    
    static func verdanaBold(size: CGFloat) -> UIFont {
        return font(name: "Verdana-Bold", size: size)
    }
    
    static func verdanaBoldItalic(size: CGFloat) -> UIFont {
        return font(name: "Verdana-BoldItalic", size: size)
    }
}


// MARK: - Private methods

fileprivate extension UIFont {
    
    // Will always pass a valid font. If font added doesnt exist will send a default font
    static func font(name: String, size: CGFloat) -> UIFont {
        if let font = UIFont(name: name, size: size) {
            return font
        } else {
            return UIFont(name: "HelveticaNeue", size: size)!
        }
    }
}
