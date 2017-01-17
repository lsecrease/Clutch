//
//  GameInfoHeaderView.swift
//  CL
//
//  Created by iwritecode on 12/6/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//

import UIKit


class GameInfoHeaderView: UICollectionReusableView {
    
    
    // MARK: IBOutlets

    @IBOutlet weak var teamLabel1: UILabel!
    @IBOutlet weak var teamLabel2: UILabel!
    @IBOutlet weak var venueLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var teamButton1: UIButton!
    @IBOutlet weak var teamButton2: UIButton!
    
    
    // MARK: Variables and constants
    
    // var delegate: GameInfoHeaderViewDelegate?
    
    var team1: String = "" {
        didSet {
            teamLabel1.text = team1
        }
    }
    
    var team2: String = "" {
        didSet {
            teamLabel2.text = team2
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
    
    @IBAction func buttonPressed() {
    
        teamButtonpressed()
    }
    
    func teamButtonpressed() {
        
    }
    

}
