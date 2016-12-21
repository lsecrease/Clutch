//
//  LiveLeaderboardController.swift
//  CL
//
//  Created by iwritecode on 12/4/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//

import UIKit


class LiveLeaderboardController: UIViewController {
    
    // Live view properties
    let idCellGameInfo = "idCellGameInfo"
    let idCellLeaderboard = "idCellLeaderboard"
    
    
    @IBOutlet weak var liveLeaderboardView: UIView!
    @IBOutlet weak var leaderboardCollectionView: UICollectionView!

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
    }
    
    func configureViews() {
        registerCells()
    }
    
    func registerCells() {
        leaderboardCollectionView.registerNib(UINib(nibName: "GameInfoCell", bundle: nil), forCellWithReuseIdentifier: idCellGameInfo)
        leaderboardCollectionView.registerNib(UINib(nibName: "LeaderboardCell", bundle: nil), forCellWithReuseIdentifier: idCellLeaderboard)

    }

    
    
}

extension LiveLeaderboardController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        return RankedUsers.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
                
        switch indexPath.row {
            
        case 0:
            let cell = leaderboardCollectionView.dequeueReusableCellWithReuseIdentifier(idCellGameInfo, forIndexPath: indexPath) as! GameInfoCell
            return cell
            
        default:
            let cell = leaderboardCollectionView.dequeueReusableCellWithReuseIdentifier(idCellLeaderboard, forIndexPath: indexPath) as! LeaderboardCell
            let user = RankedUsers[indexPath.row - 1]
            cell.rankLabel.text = "\(user.rank)"
            cell.usernameLabel.text = user.username
            cell.pointsLabel.text = "\(user.points)" + " pts"
            return cell
        }

    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let cellWidth: CGFloat = self.view.bounds.width - 15.0
        var cellHeight: CGFloat!
        
        switch indexPath.row {
        case 0: cellHeight = 60.0
        default: cellHeight = 68.0
        }
        return CGSize(width: cellWidth, height: cellHeight)
    }

    
}

