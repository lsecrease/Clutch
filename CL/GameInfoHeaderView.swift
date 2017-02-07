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
    
    func configureHeader(game: Game){
        
        self.teamLabel1.text = game.team1.name as String ?? ""
        teamLabel2.text = game.team2.name
        venueLabel.text = game.venue
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        
        if let safeDate = game.gameStartTime{ //Seth: gameStartTime or endRegistration?
            dateLabel.text = dateFormatter.string(from: safeDate)
            timeLabel.text = timeFormatter.string(from: safeDate)
        }
        
        
    }

}
