//
//  Extensions.swift
//  CL
//
//  Created by iwritecode on 11/27/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//

import Foundation


extension UIButton {
    
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