//
//  UIColor+Project.swift
//  Security
//
//  Created by Mike Lepore on 6/1/17.
//  Copyright © 2017 Ameropel. All rights reserved.
//

import UIKit

extension UIColor {

    // MARK: - Project Colors
    
    class var mainColor: UIColor { return self.azureRadiance }
    class var secondaryColor: UIColor { return self.granite }
    class var secondaryLightColor: UIColor { return self.graniteLight }
    
    
    // MARK: - White & Black
    
    static func black(withAlpha alpha: CGFloat) -> UIColor {
        return color(fromHex: 0x000000, alpha: alpha)
    }
    
    static func white(withAlpha alpha: CGFloat) -> UIColor {
        return color(fromHex: 0xFFFFFF, alpha: alpha)
    }
    
    
    // MARK: - Color Pallete
    
    class var azureRadiance: UIColor {
        return UIColor(red: 0.0 / 255.0, green: 122.0 / 255.0, blue: 255.0 / 255, alpha: 1.0)
    }
    
    class var tomato: UIColor {
        return UIColor(red: 230.0 / 255.0, green: 61.0 / 255.0, blue: 50.0 / 255, alpha: 1.0)
    }
    
    class var darkAmber: UIColor {
        return color(fromHex: 0xFF6F00, alpha: 1.0)
    }
    
    // Grays
    
    class var granite: UIColor {
        return color(fromHex: 0x212121, alpha: 1.0)
    }
    
    class var graniteLight: UIColor {
        return color(fromHex: 0x616161, alpha: 1.0)
    }
}


// MARK: - Private Methods

fileprivate extension UIColor {
    
    static func color(fromHex hex: Int) -> UIColor {
        return color(fromHex: hex, alpha: 1.0)
    }
    
    static func color(fromHex hex: Int, alpha: CGFloat) -> UIColor {
        let redComponent = CGFloat((hex >> 16 & 0xFF)) / 255.0
        let greenComponent = CGFloat((hex >> 8 & 0xFF)) / 255.0
        let blueComponent = CGFloat((hex & 0xFF)) / 255.0
        
        return UIColor(red: redComponent, green: greenComponent, blue: blueComponent, alpha: alpha)
    }
    
}
