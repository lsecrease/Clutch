//
//  GameInfoHeaderView.swift
//  CL
//
//  Created by iwritecode on 12/6/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//

import UIKit

class GameInfoHeaderView: UIView {

    @IBOutlet weak var awayTeamLabel: UILabel!
    @IBOutlet weak var homeTeamLabel: UILabel!
    @IBOutlet weak var venueLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var awayTeam: String = "" {
        didSet {
            awayTeamLabel.text = awayTeam
        }
    }
    
    var homeTeam: String = "" {
        didSet {
            homeTeamLabel.text = homeTeam
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    

}
