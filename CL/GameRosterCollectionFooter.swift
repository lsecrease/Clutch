//
//  GameRosterCollectionFooter.swift
//  CL
//
//  Created by iwritecode on 12/29/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//

import UIKit

class GameRosterCollectionFooter: UICollectionReusableView {

    @IBOutlet weak var saveRosterButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        saveRosterButton.layer.cornerRadius = 3
        saveRosterButton.layer.borderWidth = 1.0
        saveRosterButton.layer.borderColor = self.tintColor.CGColor
        
    }
    
}
