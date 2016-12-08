//
//  GameRosterCell.swift
//  CL
//
//  Created by iwritecode on 12/6/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//

import UIKit

class GameRosterCell: UICollectionViewCell {
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var button: AddOrRemoveButton!
    
    var padding: CGFloat = 3.0
    
    var number: String = "" {
        didSet {
            numberLabel.text = number
        }
    }
    
    var playerName: String = "" {
        didSet {
            playerNameLabel.text = playerName
        }
    }
    
    var teamName: String = "" {
        didSet {
            teamNameLabel.text = teamName
        }
    }
    
    var cost: String = "" {
        didSet {
            costLabel.text = cost
        }
    }
    
    var hasBeenSelected = false
    
    var isShowingClose = false
    
    private var change: CGFloat!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    

}
