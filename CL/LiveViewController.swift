//
//  LiveViewController.swift
//  CL
//
//  Created by iwritecode on 12/24/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//

import Firebase
import UIKit


class LiveViewController: UIViewController {
    
    @IBOutlet weak var liveTeamView: UIView!
    @IBOutlet weak var liveTeamViewCenterX: NSLayoutConstraint!
    @IBOutlet weak var leaderboardView: UIView!
    @IBOutlet weak var leaderboardViewCenterX: NSLayoutConstraint!
    
    @IBOutlet weak var liveTeamCollectionView: UICollectionView!
    @IBOutlet weak var leaderboardCollectionView: UICollectionView!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var totalPointsLabel: UILabel!
    
    @IBOutlet weak var leaderboardButton: UIButton!
    @IBOutlet weak var myTeamButton: UIButton!
    
    var teamRef1 = FIRDatabaseReference()
    var teamRef2 = FIRDatabaseReference()

    // Cell Identifiers
    let idCellLeaderboard = "idCellLeaderboard"
    let idCellLiveTeam = "idCellLiveTeam"
    
    var liveTeamViewIsActive = true

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerCells()
        
        // setLiveTeamViewState()
        
        // Position live views
        leaderboardViewCenterX.constant += self.view.bounds.width
        liveTeamViewCenterX.constant = self.view.bounds.origin.x

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        setLiveTeamViewState()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        

    }
    
    func loadData() {
        
    }
    
    func team1ButtonPressed() {

    }
    
    func team2ButtonPressed() {

    }

    
    /// MARK: IBActions
    
    @IBAction func bottomTabButtonPressed(sender: UIButton) {
        switch sender {
        case leaderboardButton:
            UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveLinear, animations: {
                self.liveTeamViewCenterX.constant -= self.view.bounds.width
                self.leaderboardViewCenterX.constant -= self.view.bounds.width
                self.view.layoutIfNeeded()
                self.liveTeamViewIsActive = false
                // self.setLiveTeamViewState()
                
                dispatch_async(dispatch_get_main_queue(), {
                    if let mainVC = self.parentViewController as? MainViewController {
                        mainVC.checkInbutton.hide()
                    }
                })

            }) { (finished) in
            }
        case myTeamButton:
            UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveLinear, animations: {
                self.liveTeamViewCenterX.constant += self.view.bounds.width
                self.leaderboardViewCenterX.constant += self.view.bounds.width
                self.view.layoutIfNeeded()
                self.liveTeamViewIsActive = true
                // self.setLiveTeamViewState()
                
                dispatch_async(dispatch_get_main_queue(), { 
                    if let mainVC = self.parentViewController as? MainViewController {
                        mainVC.checkInbutton.show()
                    }
                })
                
            }) { (finished) in
                
            }
        default:
            break
        }
        
        self.setLiveTeamViewState()
    }
    
    func registerCells() {
        liveTeamCollectionView.registerNib(UINib(nibName: "LiveTeamCell", bundle: nil), forCellWithReuseIdentifier: idCellLiveTeam)
        leaderboardCollectionView.registerNib(UINib(nibName: "LeaderboardCell", bundle: nil), forCellWithReuseIdentifier: idCellLeaderboard)

    }
    
    func setLiveTeamViewState() {
        if let mainVC = self.parentViewController as? MainViewController {
            mainVC.liveTeamViewIsActive = self.liveTeamViewIsActive
         }
    }
    

}


// MARK: - UiCollectionView DataSource and Delegate functions

extension LiveViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == liveTeamCollectionView {
            return players.count
        } else {
            return RankedUsers.count
        }
        
    }

    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if collectionView == liveTeamCollectionView {
            // Access the first player's info
            let player = players[indexPath.row]
            let cell = liveTeamCollectionView.dequeueReusableCellWithReuseIdentifier(idCellLiveTeam, forIndexPath: indexPath) as! LiveTeamCell
            cell.playerNumberLabel.text = "\(player.number)"
            cell.playerNameLabel.text = player.name
            //            cell.teamNameLabel.text = player.teamName
            cell.playerPointLabel.text = "\(player.pointValue)"
            return cell

        } else {
            let cell = leaderboardCollectionView.dequeueReusableCellWithReuseIdentifier(idCellLeaderboard, forIndexPath: indexPath) as! LeaderboardCell
            let user = RankedUsers[indexPath.row]
            cell.rankLabel.text = "\(user.rank)"
            cell.usernameLabel.text = user.username
            cell.pointsLabel.text = "\(user.points)" + " pts"
            return cell
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let headerView = liveTeamCollectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "idCellHeaderGameInfo", forIndexPath: indexPath) as! GameInfoHeaderView
        
        headerView.teamButton1.addTarget(self, action: #selector(team1ButtonPressed), forControlEvents: .TouchUpInside)
        headerView.teamButton2.addTarget(self, action: #selector(team2ButtonPressed), forControlEvents: .TouchUpInside)

        
        return headerView
    }
    
}


// MARK:- UICollectionView Delegate Flow Layout

extension LiveViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let cellWidth: CGFloat = self.view.bounds.width - 15.0
        let cellHeight: CGFloat = 70.0
        return CGSize(width: cellWidth, height: cellHeight)
    }

}






