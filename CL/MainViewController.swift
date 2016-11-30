//
//  MainViewController.swift
//  CL
//
//  Created by iwritecode on 11/26/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    let segmentTitles = ["Profile", "Game", "Live"]
    
    
    // MARK: Main IBOutlets
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var gameButton: UIButton!
    @IBOutlet weak var liveButton: UIButton!
    
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var liveView: UIView!
    
    var currentView: UIView!
    
    // MARK: Profile IBOutlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    
    // MARK: Live View
    
    // Live View IBOutlets
    @IBOutlet weak var liveCollectionView: UICollectionView!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var totalPointsLabel: UILabel!
    
    // Live view properties
    let gameInfoCellID = "gameInfoCell"
    let playerInfoCellID = "playerInfoCell"
    
    // Test data
    let players: [Player] = [
        Player(number: "2", name: "Devin Thomas", teamName: "Wake Forest", pointValue: 41),
        Player(number: "11", name: "Greg McClinton", teamName: "Wake Forest", pointValue: 39),
        Player(number: "2", name: "Chase Jeter", teamName: "Duke", pointValue: 37),
        Player(number: "5", name: "Luke Kennard", teamName: "Duke", pointValue: 34),
        Player(number: "4", name: "Doral Moore", teamName: "Wake Forest", pointValue: 32),
        Player(number: "3", name: "Grayson Allen", teamName: "Duke", pointValue: 29)
    ]

    
    // MARK: IBActions
    @IBAction func sectionButtonPressed(sender: UIButton) {
        
        switch sender {
            
        case profileButton:
            profileButton.addUnderline()
            gameButton.removeUnderline()
            liveButton.removeUnderline()
            
            showView(profileView)
            
        case gameButton:
            profileButton.removeUnderline()
            gameButton.addUnderline()
            liveButton.removeUnderline()
            
            
        case liveButton:
            profileButton.removeUnderline()
            gameButton.removeUnderline()
            liveButton.addUnderline()
            
            showView(liveView)
            
        default:
            break
            
        }
    }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        configureViews()
    }
    
    override func viewDidLayoutSubviews() {
        
        // After all subview layout, use actual profile image view
        // width to make it round.
        let imgWidth = profileImageView.bounds.width
        profileImageView.layer.cornerRadius = imgWidth / 2.0
        
    }
    
    // MARK: Custom UI functions

    func configureViews() {
        
        profileButton.addUnderline()
        currentView = profileView
        
        registerCells()

    }
    
    // MARK: Utility functions
    
    func registerCells() {
        liveCollectionView.registerNib(UINib(nibName: "PlayerInfoCell", bundle: nil), forCellWithReuseIdentifier: playerInfoCellID)
        liveCollectionView.registerNib(UINib(nibName: "GameInfoCell", bundle: nil), forCellWithReuseIdentifier: gameInfoCellID)
        
    }
    
    func showView(view: UIView) {
        if !view.hidden {
            return
        } else {
            view.alpha = 0
            view.hidden = true
            
            UIView.animateWithDuration(0.3, animations: {
                view.hidden = false
                self.currentView.alpha = 0
                view.alpha = 1
                self.currentView.hidden = true
                
                }, completion: { (true) in
                    self.currentView = view
            })
        }
    }


}


// MARK: - UICollectionView Data Source and Delegate functions

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // Set count to include game information on first row
        return players.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        var cell = LiveInfoCell()
        
        if indexPath.row == 0 {
            cell = liveCollectionView.dequeueReusableCellWithReuseIdentifier(gameInfoCellID, forIndexPath: indexPath) as! LiveInfoCell
            cell.venueLabel.text = "Comcast Arena"
            cell.dateLabel.text = "Thurs, September 9"
            cell.timeLabel.text = "10:00pm"
        } else {
            // Access the first player's info
            let player = players[indexPath.row - 1]
            
            cell = liveCollectionView.dequeueReusableCellWithReuseIdentifier(playerInfoCellID, forIndexPath: indexPath) as! LiveInfoCell
            cell.playerNumberLabel.text = player.number
            cell.playerNameLabel.text = player.name
            cell.teamNameLabel.text = player.teamName
            cell.playerPointLabel.text = "\(player.pointValue)"
        }
        
        return cell
        
    }
    
}


// MARK: - UICollection View Delegate Flow Layout function(s)

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let cellWidth: CGFloat = self.view.bounds.width - 15.0
        let cellHeight: CGFloat = 68.0
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

