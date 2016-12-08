//
//  GameInfoCell.swift
//  CL
//
//  Created by iwritecode on 12/4/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//

import UIKit

class GameInfoCell: UICollectionViewCell {
    
    // MARK: GameInfoCell IBOutlets
    @IBOutlet weak var teamLabel1: UILabel!
    @IBOutlet weak var teamLabel2: UILabel!
    @IBOutlet weak var venueLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var awayTeam: String = "" {
        didSet {
            teamLabel1.text = awayTeam
        }
    }
    
    var homeTeam: String = "" {
        didSet {
            teamLabel2.text = homeTeam
        }
    }
    
    var venue: String = "" {
        didSet {
            venueLabel.text = venue
        }
    }
    
    var date: String = "" {
        didSet {
            dateLabel.text = date
        }
    }
    
    var time: String = "" {
        didSet {
            timeLabel.text = time
        }
    }

    
}
