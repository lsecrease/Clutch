//
//  LiveTeamCell.swift
//  CL
//
//  Created by iwritecode on 12/4/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//

import UIKit

class LiveTeamCell: UICollectionViewCell {
    
    // MARK: PlayerInfoCell IBOutlets
    @IBOutlet weak var playerNumberLabel: UILabel!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var playerPointLabel: UILabel!
    
    var playerNumber: Int = 0 {
        didSet {
            playerNumberLabel.text = "\(playerNumber)"
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
    
    var playerPoint: String = "" {
        didSet {
            playerPointLabel.text = playerPoint
        }
    }
}
