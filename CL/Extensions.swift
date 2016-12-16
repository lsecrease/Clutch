//
//  Extensions.swift
//  CL
//
//  Created by iwritecode on 11/27/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//

import Foundation

// MARK: - UIButton extensions 

extension UIButton {
    
    // Underline button label text
    func addUnderline() {
        let underlineAttr = [NSUnderlineStyleAttributeName : 1]
        
        if let title = self.titleLabel!.text {
            let underlinedTitle = NSMutableAttributedString(string: title, attributes: underlineAttr)
            self.setAttributedTitle(underlinedTitle, forState: .Normal)
        }
    }
    
    func removeUnderline() {
        if let title = self.titleLabel!.text {
            let normalTitle = NSMutableAttributedString(string: title)
            
            UIView.performWithoutAnimation({
                self.setAttributedTitle(normalTitle, forState: .Normal)
            })

        }
    }
    
    
}


// MARK: - UILabel extensions

extension UILabel {
    
//    func show() {
//        self.hidden = true
//        self.alpha = 0
//
//        UIView.animateWithDuration(0.3) {
//            self.hidden = false
//            self.alpha = 1
//        }
//    }
//    
//    func hide() {
//        self.alpha = 1
//        self.hidden = false
//        
//        UIView.animateWithDuration(0.3) { 
//            self.alpha = 0
//            self.hidden = true
//        }
//    }
    
}


// MARK: - UIView extensions

extension UIView {
    
    func slideLeft(duration duration: NSTimeInterval) {
        let slideLeftTransition = CATransition()
        slideLeftTransition.duration = duration
        slideLeftTransition.type = kCATransitionPush
        slideLeftTransition.subtype = kCATransitionFromRight
        // slideRightTransition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        slideLeftTransition.fillMode = kCAFillModeRemoved
        self.layer.addAnimation(slideLeftTransition, forKey: "slideRightTransition")
        
    }
    
    
    func show() {
        self.hidden = true
        self.alpha = 0
        
        UIView.animateWithDuration(0.3) {
            self.hidden = false
            self.alpha = 1
        }
    }
    
    func hide() {
        self.alpha = 1
        self.hidden = false
        
        UIView.animateWithDuration(0.3) {
            self.alpha = 0
            self.hidden = true
        }
    }

    func rotate(duration: NSTimeInterval, fromValue: CGFloat, toValue: CGFloat) {
        
        UIView.animateWithDuration(duration, delay: 0.0, options: [], animations: { 
            let rotation = CABasicAnimation(keyPath: "transform.rotation")
            rotation.fromValue = fromValue
            rotation.toValue = CGFloat(M_PI) * toValue
            self.layer.addAnimation(rotation, forKey: nil)
            self.layoutSubviews()
            }) { (finished) in
                // Perform tasks after finishing...
                
        }
        
    }
    

}

