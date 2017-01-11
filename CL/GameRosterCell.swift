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
    @IBOutlet weak var button: RotatingButton!
    
    var padding: CGFloat = 3.0
    
    let startImage = UIImage(named: "add")
    let endImage = UIImage(named: "delete")
    
    var willAddPlayer = true {
        didSet {
            if willAddPlayer {
                button.turnForward(endImage, padding: 0)
            } else {
                button.turnBack(startImage, padding: 1)
            }
        }
    }
    
    
    var addedToRoster = false
    
    var number: Int = 0 {
        didSet {
            numberLabel.text = "\(number)"
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
    
    private var change: CGFloat!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    
    
    
    func turnButtonForward() {
        UIView.animateWithDuration(0.2, animations: {
            self.button.transform = CGAffineTransformMakeRotation(45 * (CGFloat(M_PI) / 180.0))
            
            if self.endImage != nil {
                self.button.setImage(self.endImage, forState: .Normal)
            }
            self.layoutSubviews()
        })
    }
    
    func turnButtonBack() {
        UIView.animateWithDuration(0.2, animations: {
            self.button.transform = CGAffineTransformMakeRotation(-(CGFloat(M_PI) / 180.0))
            
            if self.startImage != nil {
                self.button.setImage(self.startImage, forState: .Normal)
            }
            self.layoutSubviews()

        })
    }

    

}
