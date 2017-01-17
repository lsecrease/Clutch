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

//    func rotate(duration: NSTimeInterval, fromValue: CGFloat, toValue: CGFloat) {
//        
//        UIView.animateWithDuration(duration, delay: 0.0, options: [], animations: { 
//            let rotation = CABasicAnimation(keyPath: "transform.rotation")
//            rotation.fromValue = fromValue
//            rotation.toValue = CGFloat(M_PI) * toValue
//            self.layer.addAnimation(rotation, forKey: nil)
//            self.layoutSubviews()
//            }) { (finished) in
//                // Perform tasks after finishing...
//                
//        }
//        
//    }

}

extension UIImageView {
    
    /*  This function makes an imageView rotate to a specified angle e.g. 45 degrees.
     It can be called to both turn an image forward and back. 
     
     EXAMPLE: Making an imageView turn forward 45 degrees
          
        1a) Call the function and set the angle to 45 and the direction to '.Clockwise'.
        b) Set finalImage to 'nil' or a UIImage depending on whether you want a different
            after once rotated or not.
        2a) If you wish to rotate the image back, call the function again and set
            the angle to 1 and the direction to '.CounterClockwise'
     */
    func turn(angle: CGFloat, direction: RotationDirection, finalImage: UIImage?) {
        var angleToTurn: CGFloat!
        
        if direction == .CounterClockwise {
            angleToTurn = angle * -1.0
        } else {
            angleToTurn = angle
        }
        
        UIView.animateWithDuration(0.2, animations: {
            self.transform = CGAffineTransformMakeRotation(angleToTurn * (CGFloat(M_PI) / 180.0))
            
            if finalImage != nil {
                self.image = finalImage
            }
            
            self.layoutSubviews()
        })
    }
    
}
