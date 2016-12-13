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
    
    @IBOutlet weak var profileUnderlineLabel: UILabel!
    @IBOutlet weak var gameUnderlineLabel: UILabel!
    @IBOutlet weak var liveUnderlineLabel: UILabel!
    
    @IBOutlet weak var profileView: UIView!
    
    var currentView: UIView!
    
    // MARK: Profile IBOutlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    
    // MARK: LIVE VIEW
    @IBOutlet weak var checkInButton: UIButton!
    @IBOutlet weak var liveView: UIView!
    @IBOutlet weak var liveTeamView: UIView!
    @IBOutlet weak var liveTeamViewCenterX: NSLayoutConstraint!
    @IBOutlet weak var leaderboardView: UIView!
    @IBOutlet weak var leaderboardViewCenterX: NSLayoutConstraint!
    
    var liveTeamViewIsActive: Bool = false
    
    
    // MARK: Live Team View
    
    // Live Team View IBOutlets
    @IBOutlet weak var liveTeamCollectionView: UICollectionView!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var totalPointsLabel: UILabel!
    
    // Live Team view properties
    let idCellGameInfo = "idCellGameInfo"
    let idCellLeaderboard = "idCellLeaderboard"
    let idCellLiveTeam = "idCellLiveTeam"

    
    // MARK: GAME VIEW
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var gameMatchupView: UIView!
    @IBOutlet weak var gameMatchupCollectionView: UICollectionView!
    @IBOutlet weak var gameRosterCollectionView: UICollectionView!
    @IBOutlet weak var gameMatchupViewCenterX: NSLayoutConstraint!
    @IBOutlet weak var gameRosterViewCenterX: NSLayoutConstraint!
    var gameMatchupViewIsActive = false

    // MARK Live Leadeboard View
    
    // IBOutlets
    @IBOutlet weak var leaderboardCollectionView: UICollectionView!

    
    // MARK: IBActions
    @IBAction func sectionButtonPressed(sender: UIButton) {
        
        currentView.hide()
        
        switch sender {
            
        case profileButton:
            profileUnderlineLabel.show()
            gameUnderlineLabel.hide()
            liveUnderlineLabel.hide()
            profileView.show()
            gameView.hide()
            currentView = profileView
            
            updateViews()
        case gameButton:
            profileUnderlineLabel.hide()
            gameUnderlineLabel.show()
            liveUnderlineLabel.hide()
            gameView.show()
            profileView.hide()
            liveView.hide()
            currentView = gameView
            
            updateViews()
        case liveButton:
            profileUnderlineLabel.hide()
            gameUnderlineLabel.hide()
            liveUnderlineLabel.show()
            liveView.show()
            gameView.hide()
            profileView.hide()
            currentView = liveView
            
            checkInButton.show()
            updateViews()
        default:
            break
            
        }
    }
    
    @IBAction func leaderboardButtonPressed(sender: UIButton) {
        UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveLinear, animations: {
            self.liveTeamViewCenterX.constant -= self.view.bounds.width
            self.leaderboardViewCenterX.constant -= self.view.bounds.width
            self.view.layoutIfNeeded()
            }, completion: nil)
        
        checkInButton.hide()
    }
    
    @IBAction func myTeamButtonPressed(sender: UIButton) {
        UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveLinear, animations: {
            self.liveTeamViewCenterX.constant += self.view.bounds.width
            self.leaderboardViewCenterX.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
            }, completion: nil)
        
        checkInButton.show()
    }
    
    @IBAction func cancelRosterButtonPressed(sender: UIButton) {
        self.slideViewCenterXConstraints(gameMatchupViewCenterX, centerXConstraint2: gameRosterViewCenterX, direction: .Left)
        cancelButton.hide()
    }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Position Live views
        leaderboardViewCenterX.constant += self.view.bounds.width
        liveTeamViewCenterX.constant = self.view.bounds.origin.x
        
        // Position GAME views
        gameRosterViewCenterX.constant += self.view.bounds.width

    }
    
    override func viewDidLayoutSubviews() {
        
        // After all subview layout, use actual profile image view
        // width to make it round.
        let imgWidth = profileImageView.bounds.width
        profileImageView.layer.cornerRadius = imgWidth / 2.0
        
        // liveView2CenterX.constant -= self.view.bounds.width

    }
    
    // MARK: Custom UI functions

    func configureViews() {
        
        // Indicate and set current view is profileView
        profileUnderlineLabel.show()
        currentView = profileView
        
        // Register Collection view cells
        registerCells()

    }
    
    func updateViews() {
        if liveTeamViewIsActive {
            checkInButton.show()
        } else {
            checkInButton.hide()
        }
        
//        if gameMatchupViewIsActive {
//            cancelButton.show()
//        } else {
//            cancelButton.hide()
//        }
        
        if self.view.subviews.last == liveTeamView {
            checkInButton.show()
        } else {
            checkInButton.hide()
        }
        
        if self.view.subviews.first == gameMatchupView {
            
            print("GAME MATCHUP VIEW IS SHOWING")
            
            cancelButton.show()
        } else {
            cancelButton.hide()
        }
    
    }
    
    // MARK: Utility functions
    
    func registerCells() {
        
        // LIVE Collection Views
        liveTeamCollectionView.registerNib(UINib(nibName: "LiveTeamCell", bundle: nil), forCellWithReuseIdentifier: idCellLiveTeam)
        liveTeamCollectionView.registerNib(UINib(nibName: "GameInfoCell", bundle: nil), forCellWithReuseIdentifier: idCellGameInfo)
        leaderboardCollectionView.registerNib(UINib(nibName: "GameInfoCell", bundle: nil), forCellWithReuseIdentifier: idCellGameInfo)
        leaderboardCollectionView.registerNib(UINib(nibName: "LeaderboardCell", bundle: nil), forCellWithReuseIdentifier: idCellLeaderboard)
        
        // GAME CollectionViews
        gameMatchupCollectionView.registerNib(UINib(nibName: "GameMatchupCell", bundle: nil), forCellWithReuseIdentifier: "idCellGameMatchup")
        gameRosterCollectionView.registerNib(UINib(nibName: "GameRosterCell", bundle: nil), forCellWithReuseIdentifier: "idCellGameInfo")
        
    }
    
    func registerHeadersForCollectionCells() {

    }
    
    func swapViews(fromView fromView: UIView, toView: UIView) {
        fromView.alpha = 1
        fromView.hidden = false
        toView.alpha = 0
        toView.hidden = true

        UIView.animateWithDuration(0.2) {
            toView.hidden = false
            toView.alpha = 1
            fromView.alpha = 0
            
            toView.alpha = 1
            fromView.hidden = false
        }
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
    
    func slideViewCenterXConstraints(centerXConstraint1: NSLayoutConstraint, centerXConstraint2: NSLayoutConstraint, direction: Direction) {
        
        if direction == .Left {
            UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveLinear, animations: {
                centerXConstraint1.constant += self.view.bounds.width
                centerXConstraint2.constant += self.view.bounds.width
                self.view.layoutIfNeeded()
                }, completion: nil)
        } else if direction == .Right {
            UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveLinear, animations: {
                centerXConstraint1.constant -= self.view.bounds.width
                centerXConstraint2.constant -= self.view.bounds.width
                self.view.layoutIfNeeded()
                }, completion: nil)
        }

    }

}


// MARK: - UICollectionView DataSource and Delegate functions

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // Adjust count to include game information cell on first row
        
        if collectionView == liveTeamCollectionView || collectionView == gameRosterCollectionView {
            return players.count
        } else if collectionView == leaderboardCollectionView {
            return RankedUsers.count
        } else if collectionView == gameMatchupCollectionView {
            return GameMatchups.count
        }
        
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        switch collectionView {
            
        case liveTeamCollectionView:
            // Access the first player's info
            let player = players[indexPath.row]
            let cell = liveTeamCollectionView.dequeueReusableCellWithReuseIdentifier(idCellLiveTeam, forIndexPath: indexPath) as! LiveTeamCell
            cell.playerNumberLabel.text = player.number
            cell.playerNameLabel.text = player.name
            cell.teamNameLabel.text = player.teamName
            cell.playerPointLabel.text = "\(player.pointValue)"
            return cell
            
        case leaderboardCollectionView:
            let cell = leaderboardCollectionView.dequeueReusableCellWithReuseIdentifier(idCellLeaderboard, forIndexPath: indexPath) as! LeaderboardCell
            let user = RankedUsers[indexPath.row]
            cell.rankLabel.text = "\(user.rank)"
            cell.usernameLabel.text = user.username
            cell.pointsLabel.text = "\(user.points)" + " pts"
            return cell
        
        case gameMatchupCollectionView:
            let cell = gameMatchupCollectionView.dequeueReusableCellWithReuseIdentifier("idCellGameMatchup", forIndexPath: indexPath) as! GameMatchupCell
            let matchup = GameMatchups[indexPath.row]
            cell.awayTeam = matchup.awayTeam
            cell.homeTeam = matchup.homeTeam
            cell.venue = matchup.venue
            cell.date = matchup.date
            cell.time = matchup.time
            return cell
            
        case gameRosterCollectionView:
            
            let cell = gameRosterCollectionView.dequeueReusableCellWithReuseIdentifier("idCellGameRoster", forIndexPath: indexPath) as! GameRosterCell
            let player = players[indexPath.row]
            cell.number = player.number
            cell.playerName = player.name
            cell.teamName = player.teamName
            cell.cost = "\(player.cost)"
            return cell
            
        default:
            break
        }
        
        let cell = liveTeamCollectionView.dequeueReusableCellWithReuseIdentifier(idCellGameInfo, forIndexPath: indexPath) as! GameInfoCell
        cell.venueLabel.text = "Comcast Arena"
        cell.dateLabel.text = "Thurs, September 9"
        cell.timeLabel.text = "10:00pm"
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        switch collectionView {
        
        case gameMatchupCollectionView:
            
            // Slide GAME views right to simulate navigation
            UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveLinear, animations: {
            
                self.gameRosterViewCenterX.constant -= self.view.bounds.width
                self.gameMatchupViewCenterX.constant -= self.view.bounds.width
                self.view.layoutIfNeeded()
                }, completion: nil)
            
            self.cancelButton.show()

        default:
            break
        }
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        var headerView = UICollectionReusableView()
        
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            
            switch collectionView {
            case liveTeamCollectionView, gameRosterCollectionView:
                headerView = liveTeamCollectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "idCellHeaderGameInfo", forIndexPath: indexPath)
                return headerView
            default:
                break
            }
            
        default:
            
            print(false, "Unexpected element kind")
        }
        
        return headerView
    }
}


// MARK: - UICollection View Delegate Flow Layout function(s)

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let cellWidth: CGFloat = self.view.bounds.width - 15.0
        let cellHeight: CGFloat = 70.0
        return CGSize(width: cellWidth, height: cellHeight)
    }
}


