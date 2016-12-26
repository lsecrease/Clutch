//
//  GameViewController.swift
//  CL
//
//  Created by iwritecode on 12/5/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var gameMatchupView: UIView!
    @IBOutlet weak var gameMatchupCollectionView: UICollectionView!
    @IBOutlet weak var gameRosterCollectionView: UICollectionView!
    @IBOutlet weak var gameMatchupViewCenterX: NSLayoutConstraint!
    @IBOutlet weak var gameRosterViewCenterX: NSLayoutConstraint!


    override func viewDidLoad() {
        super.viewDidLoad()

        registerCells()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        gameRosterViewCenterX.constant += self.view.bounds.width
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerCells() {
        // GAME CollectionViews
        gameMatchupCollectionView.registerNib(UINib(nibName: "GameMatchupCell", bundle: nil), forCellWithReuseIdentifier: "idCellGameMatchup")
        gameRosterCollectionView.registerNib(UINib(nibName: "GameRosterCell", bundle: nil), forCellWithReuseIdentifier: "idCellGameInfo")

    }
    

}

extension GameViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if collectionView == gameMatchupCollectionView {
            let cell = gameMatchupCollectionView.dequeueReusableCellWithReuseIdentifier("idCellGameMatchup", forIndexPath: indexPath) as! GameMatchupCell
            let matchup = GameMatchups[indexPath.row]
            cell.awayTeam = matchup.awayTeam
            cell.homeTeam = matchup.homeTeam
            cell.venue = matchup.venue
            cell.date = matchup.date
            cell.time = matchup.time
            return cell
        } else {
            let cell = gameRosterCollectionView.dequeueReusableCellWithReuseIdentifier("idCellGameRoster", forIndexPath: indexPath) as! GameRosterCell
            let player = players[indexPath.row]
            cell.number = player.number
            cell.playerName = player.name
//            cell.teamName = player.teamName
//            cell.cost = "\(player.cost)"
            return cell
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        switch collectionView {
            
        case gameMatchupCollectionView:
            
            // Slide GAME views right to simulate navigation
            UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveLinear, animations: {
                self.gameRosterViewCenterX.constant -= self.view.bounds.width
                self.gameMatchupViewCenterX.constant -= self.view.bounds.width
                self.view.layoutIfNeeded()
            }) { (finished) in
//                self.gameRosterViewIsActive = true
//                self.updateViews()
            }
            
        default:
            break
        }

    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // Adjust count to include game information cell on first row
        
        if collectionView == gameMatchupCollectionView {
            return GameMatchups.count
        } else {
            return players.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "idCellHeaderGameInfo", forIndexPath: indexPath)
        
        return headerView

    }

}

extension GameViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let cellWidth: CGFloat = self.view.bounds.width - 15.0
        let cellHeight: CGFloat = 70.0
        return CGSize(width: cellWidth, height: cellHeight)
    }
}

