//
//  RotatingButton.swift
//  CL
//
//  Created by iwritecode on 12/15/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//

import UIKit

class RotatingButton: UIButton {
    
    var isRotated: Bool = false
    
//    func turnBack(finalImage: UIImage?, padding: CGFloat) {
//        UIView.animateWithDuration(0.2, animations: {
//            self.transform = CGAffineTransformMakeRotation(-45 * (CGFloat(M_PI) / 180.0))
//            
//            if finalImage != nil {
//                self.setImage(finalImage!, forState: .Normal)
//                self.layoutSubviews()
//            }
//            
//        })
//    }
    
    func turnBack(finalImage: UIImage?, padding: CGFloat) {
        UIView.animateWithDuration(0.2, animations: {
            self.transform = CGAffineTransformMakeRotation(-45 * (CGFloat(M_PI) / 180.0))
            
            self.imageEdgeInsets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
            
            if finalImage != nil {
                self.setImage(finalImage!, forState: .Normal)
                self.layoutSubviews()
            }
            
        })
    }

    
    func turnForward(finalImage: UIImage?, padding: CGFloat) {
        UIView.animateWithDuration(0.2, animations: {
            self.transform = CGAffineTransformMakeRotation((CGFloat(M_PI) / 180.0))
            
            self.imageEdgeInsets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)

            
            if finalImage != nil {
                self.setImage(finalImage, forState: .Normal)
                self.layoutSubviews()
            }
            
        })
    }
    
    /*  This function makes a button rotate to a specified angle e.g. 45 degrees.
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
                self.setImage(finalImage, forState: .Normal)
            }
            
            self.layoutSubviews()
        })
    }

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentMode = .ScaleAspectFit
        // self.addTarget(self, action: #selector(self.buttonPressed), forControlEvents: .TouchUpInside)
        
    }
    
}
