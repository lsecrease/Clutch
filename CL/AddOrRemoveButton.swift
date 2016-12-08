//
//  AddOrRemoveButton.swift
//  CL
//
//  Created by iwritecode on 12/7/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//

import UIKit

class AddOrRemoveButton: UIButton {

    var isShowingClose: Bool = false
    var padding: CGFloat = 3.0
    
    private func showAdd() {
        UIView.animateWithDuration(0.2, animations: {
            self.transform = CGAffineTransformMakeRotation(45.0 * (CGFloat(M_PI) / 180.0))
            let pad: CGFloat = 0.5 + self.padding
            self.imageEdgeInsets = UIEdgeInsets(top: pad, left: pad, bottom: pad, right: pad)
            self.setImage(UIImage(named: "add"), forState: .Normal)
            self.layoutSubviews()
        })
        self.isShowingClose = false
    }
    
    private func showClose() {
        UIView.animateWithDuration(0.2, animations: {
            self.transform = CGAffineTransformMakeRotation(-(CGFloat(M_PI) / 180.0))
            self.imageEdgeInsets = UIEdgeInsets(top: self.padding, left: self.padding, bottom: self.padding, right: self.padding)
            self.setImage(UIImage(named: "delete"), forState: .Normal)
            self.layoutSubviews()

        })
        self.isShowingClose = true
    }
    
    func buttonPressed() {
        if isShowingClose {
            self.showAdd()
        } else {
            self.showClose()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentMode = .ScaleAspectFit
        let pad: CGFloat = 3.0
        self.imageEdgeInsets = UIEdgeInsets(top: pad, left: pad, bottom: pad, right: pad)
        self.addTarget(self, action: #selector(self.buttonPressed), forControlEvents: .TouchUpInside)

    }
    
}

