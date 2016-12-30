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
    
    func turnBack(finalImage: UIImage?) {
        UIView.animateWithDuration(0.2, animations: {
            self.transform = CGAffineTransformMakeRotation(-45 * (CGFloat(M_PI) / 180.0))
            
            if finalImage != nil {
                self.setImage(finalImage!, forState: .Normal)
            }
            
            self.layoutSubviews()
        })
    }
    
    func turnForward(finalImage: UIImage?) {
        UIView.animateWithDuration(0.2, animations: {
            self.transform = CGAffineTransformMakeRotation((CGFloat(M_PI) / 180.0))
            
            if finalImage != nil {
                self.setImage(finalImage, forState: .Normal)
                self.layoutSubviews()
            }
            
        })
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentMode = .ScaleAspectFit
        // self.addTarget(self, action: #selector(self.buttonPressed), forControlEvents: .TouchUpInside)
        
    }
    
}
