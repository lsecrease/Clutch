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
    var player = Player()
    var tapAction: ((GameRosterCell, Player) -> Bool)?
    var willAddPlayer = true
    
    
    
    func updateAddingPlayer() {
        let success = tapAction?(self, player)
        
        if success == true {
            if willAddPlayer {
                self.willAddPlayer = false
                button.turnForward(endImage, padding: 0)
            } else {
                self.willAddPlayer = true
                button.turnBack(startImage, padding: 1)
            }
        }
    }
    
    
    var addedToRoster: Bool = false{
        didSet {
            button.turnForward(endImage, padding: 0)
            willAddPlayer = false
        }
    }
    
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
    
    fileprivate var change: CGFloat!

    override func awakeFromNib() {
        super.awakeFromNib()

        
    }
    
    func configureCell(){
        self.willAddPlayer = true
        button.setImage(startImage, for: UIControlState())
        button.turnBack(startImage, padding: 1)

    }
    
    
//    func turnButtonForward() {
//        UIView.animate(withDuration: 0.2, animations: {
//            self.button.transform = CGAffineTransform(rotationAngle: 45 * (CGFloat(M_PI) / 180.0))
//            
//            if self.endImage != nil {
//                self.button.setImage(self.endImage, for: UIControlState())
//            }
//            self.layoutSubviews()
//        })
//    }
//    
//    func turnButtonBack() {
//        UIView.animate(withDuration: 0.2, animations: {
//            self.button.transform = CGAffineTransform(rotationAngle: -(CGFloat(M_PI) / 180.0))
//            
//            if self.startImage != nil {
//                self.button.setImage(self.startImage, for: UIControlState())
//            }
//            self.layoutSubviews()
//
//        })
//    }

    

}
