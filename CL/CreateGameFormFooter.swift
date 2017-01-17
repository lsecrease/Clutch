//
//  CreateGameFormFooter.swift
//  CL
//
//  Created by iwritecode on 1/16/17.
//  Copyright © 2017 iwritecode. All rights reserved.
//

import UIKit

class CreateGameFormFooter: UIView {
    
    var createGameButton = UIButton()
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
//        self.backgroundColor = UIColor.whiteColor()
//        
//        let buttonWidth: CGFloat = 150
//        let buttonHeight: CGFloat = 50
//        let margin: CGFloat = 15
//        
//        createGameButton = UIButton(frame: CGRect(x: self.bounds.width - buttonWidth - margin, y: self.bounds.height - buttonHeight - margin, width: buttonWidth, height: buttonHeight))
//        
//        createGameButton.layer.borderColor = createGameButton.titleLabel?.tintColor.CGColor
//        createGameButton.layer.cornerRadius = 5.0
//        createGameButton.layer.borderWidth = 1.0
//        
//        // self.addSubview(createGameButton)
        
        NSBundle.mainBundle().loadNibNamed("CreateGameFormFooter", owner: self, options: nil)
        self.addSubview(createGameButton)

    }
    
    class func instanceFromNib() -> UIView {
        
        let emptyView = UIView()
        
        if let footerView = UINib(nibName: "CreateGameFormFooter", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as? UIView {
            
            return footerView
        }
        return emptyView
    }

}
