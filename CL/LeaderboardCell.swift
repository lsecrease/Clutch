//
//  LeaderboardCell.swift
//  CL
//
//  Created by iwritecode on 12/4/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//

import UIKit

class LeaderboardCell: UICollectionViewCell {
    
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    
    var rank: String = "" {
        didSet {
            rankLabel.text = rank
        }
    }
    
    var username: String = "" {
        didSet {
            usernameLabel.text = username
        }
    }
    
    var points: String = "" {
        didSet {
            pointsLabel.text = points
        }
    }
    
}
