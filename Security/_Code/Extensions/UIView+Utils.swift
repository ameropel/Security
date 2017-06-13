//
//  UIView+Utils.swift
//  Pizza Me
//
//  Created by Mike Lepore on 5/12/17.
//  Copyright © 2017 Ameropel. All rights reserved.
//

import UIKit
import Foundation

extension UIView {
    
    // MARK: - Blur
    
    func addBlurView(blurStyle: UIBlurEffectStyle) {
        
        let blurEffect = UIBlurEffect(style: blurStyle)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.insertSubview(blurView, at: 0)
    }
    
    func blurViewWithVibrancy(blurStyle: UIBlurEffectStyle) -> UIVisualEffectView {
        
        let blurEffect = UIBlurEffect(style: blurStyle)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.insertSubview(blurView, at: 0)
        
        // Vibrancy Effect
        let vibrancyEffect = UIVibrancyEffect(blurEffect: UIBlurEffect(style: blurStyle))
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyView.frame = blurView.frame
        blurView.contentView.addSubview(vibrancyView)
        
        //view.center = vibrancyView.convert(vibrancyView.center, from: vibrancyView.superview)
        //vibrancyView.contentView.addSubview(view)
        
        return vibrancyView
    }
    
    func searchVisualEffectsSubview() -> UIVisualEffectView?
    {
        if let visualEffectView = self as? UIVisualEffectView
        {
            return visualEffectView
        }
        else
        {
            for subview in subviews
            {
                if let found = subview.searchVisualEffectsSubview()
                {
                    return found
                }
            }
        }
        return nil
    }
    
    
    // MARK: - Round Corners
    
    func roundCorners(corners: UIRectCorner, withRadius radius: CGFloat) {
        
        let path = UIBezierPath(roundedRect:self.bounds, byRoundingCorners:corners, cornerRadii: CGSize(width: radius, height:  radius))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
}
