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
    var endImage: UIImage?
    var startImage: UIImage?
    
    func rotateForward() {
        UIView.animateWithDuration(0.2, animations: {
            self.transform = CGAffineTransformMakeRotation(45 * (CGFloat(M_PI) / 180.0))
            
            if self.endImage != nil {
                self.setImage(self.endImage!, forState: .Normal)
            }
            
            self.layoutSubviews()
        })
    }
    
    func rotateToOrigin() {
        UIView.animateWithDuration(0.2, animations: {
            self.transform = CGAffineTransformMakeRotation(-(CGFloat(M_PI) / 180.0))
            
            if self.startImage != nil {
                self.setImage(self.startImage, forState: .Normal)
                self.layoutSubviews()
            }
            
        })
    }
    
    func buttonPressed() {
        
        isRotated = !isRotated
        
        if isRotated {
            self.rotateForward()
        } else {
            self.rotateToOrigin()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentMode = .ScaleAspectFit
        self.addTarget(self, action: #selector(self.buttonPressed), forControlEvents: .TouchUpInside)
        
    }
    
}
