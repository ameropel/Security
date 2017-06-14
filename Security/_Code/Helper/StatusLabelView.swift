//
//  StatusLabelView.swift
//  Security
//
//  Created by Mike Lepore on 6/9/17.
//  Copyright © 2017 Ameropel. All rights reserved.
//

import UIKit

@IBDesignable
class StatusLabelView: UIView {
    
    private let displayTime: CGFloat = 2.0
    private var label: UILabel!
    
    var textAlignment: NSTextAlignment = .center {
        didSet {
            if label != nil {
                label.textAlignment = self.textAlignment
            }
        }
    }

    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureUI()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.configureInspector()
    }

    
    // MARK: - UI
    
    private func configureUI() {
        
        self.configureInspector()
        self.alpha = 0
    }
    
    private func configureInspector() {
        
        self.backgroundColor = .clear
        
        // Create Label
        self.label = UILabel(frame: self.bounds)
        self.label.textAlignment = self.textAlignment
        self.label.textColor = UIColor.tomato.withAlphaComponent(0.9)
        self.label.font = UIFont.verdana(size: 10)
        self.label.text = "Error Label Text"
        self.label.numberOfLines = 0
        self.label.backgroundColor = .clear
        self.addSubview(self.label)
    }
    
    
    // MARK: - Display
    
    func showErrorWithMessage(message: String) {
        
        self.label.text = message
        self.label.textColor = UIColor.tomato.withAlphaComponent(0.9)
        
        UIView.animate(withDuration: 0.4, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
            self.alpha = 1
        }, completion: { (finished) -> Void in
            UIView.animate(withDuration: 0.4, delay: TimeInterval(self.displayTime), options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
                self.alpha = 0
            }, completion: { (finished) -> Void in
            })
        })
    }
    
    func showSuccessWithMessage(message: String) {
        
        self.label.text = message
        self.label.textColor = UIColor.green.withAlphaComponent(0.9)
        
        UIView.animate(withDuration: 0.4, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
            self.alpha = 1
        }, completion: { (finished) -> Void in
            UIView.animate(withDuration: 0.4, delay: TimeInterval(self.displayTime), options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
                self.alpha = 0
            }, completion: { (finished) -> Void in
            })
        })
    }
}
