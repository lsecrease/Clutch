//
//  GameCell.swift
//  CL
//
//  Created by Zachary Hein on 2/2/17.
//  Copyright © 2017 iwritecode. All rights reserved.
//

import UIKit

class GameCell: UITableViewCell {
    @IBOutlet weak var gameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var finishedButton: UIButton!

    var tapAction: ((GameCell) -> Void)?

    // MARK: - Life Cycle Methods
    
    // MARK: - Actions
    @IBAction func finishedButtonPressed(_ sender: Any) {
        tapAction?(self)
    }
    
    // MARK: - Custom methods
    func configureCell(game: Game){
        self.finishedButton.isHidden = false
        self.finishedButton.layoutIfNeeded()
        self.finishedButton.layer.cornerRadius = 4
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let name = game.team1.name + " | " + game.team2.name
        
        gameLabel.text = name
        if let safeDate = game.gameStartTime{
            dateLabel.text = dateFormatter.string(from: safeDate)
        }
        if let _ = game.endGameTime{
            self.finishedButton.isHidden = true
        }else{
            self.finishedButton.isHidden = false
        }
        
    }

}
