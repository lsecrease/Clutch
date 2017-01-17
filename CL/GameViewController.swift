//
//  GameViewController.swift
//  CL
//
//  Created by iwritecode on 12/5/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//

import Firebase
import UIKit


// MARK: - GameViewController

class GameViewController: UIViewController {
    
    // MARK: Game properties
    
    var game = Game()
    var gameRosterViewIsActive = false

    
    // MARK: IBOutlets
        
    @IBOutlet weak var gameMatchupView: UIView!
    @IBOutlet weak var gameMatchupCollectionView: UICollectionView!
    @IBOutlet weak var gameRosterCollectionView: UICollectionView!
    @IBOutlet weak var gameMatchupViewCenterX: NSLayoutConstraint!
    @IBOutlet weak var gameRosterViewCenterX: NSLayoutConstraint!

    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerCells()
        
        // Set center constraints
        // Note: MUST be set in viewDidLoad for proper alignment.
        gameMatchupViewCenterX.constant = self.view.bounds.origin.x
        gameRosterViewCenterX.constant += self.view.bounds.width

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerCells() {
        // GAME CollectionViews
        gameMatchupCollectionView.registerNib(UINib(nibName: "GameMatchupCell", bundle: nil), forCellWithReuseIdentifier: "idCellGameMatchup")
        gameRosterCollectionView.registerNib(UINib(nibName: "GameRosterCell", bundle: nil), forCellWithReuseIdentifier: "idCellGameInfo")
        gameRosterCollectionView.registerNib(UINib(nibName: "GameRosterCollectionFooter", bundle: nil), forCellWithReuseIdentifier: "idFooterGameRoster")

    }
    
    
    func setGameRosterViewState() {
        if let mainVC = self.parentViewController as? MainViewController {
            mainVC.gameRosterViewIsActive = self.gameRosterViewIsActive
        }
    }

    func slideGameViews(direction direction: Direction) {
        switch direction {
        case .Right:
            UIView.animateWithDuration(0.2) {
                self.gameRosterViewCenterX.constant += self.view.bounds.width
                self.gameMatchupViewCenterX.constant += self.view.bounds.width
                self.view.layoutIfNeeded()
                self.gameRosterViewIsActive = false
                
                if let mainVC = self.parentViewController as? MainViewController {
                    mainVC.cancelButton.hide()
                }
            }
        case .Left:
            UIView.animateWithDuration(0.2) {
                self.gameRosterViewCenterX.constant -= self.view.bounds.width
                self.gameMatchupViewCenterX.constant -= self.view.bounds.width
                self.view.layoutIfNeeded()
                self.gameRosterViewIsActive = true
                
                if let mainVC = self.parentViewController as? MainViewController {
                    mainVC.cancelButton.show()
                }
            }
        }
        
        setGameRosterViewState()
        
    }
    
    
    func teamButton1Pressed() {
        print("TEAM 1 BUTTON PRESSED!")
    }
    
    func teamButton2Pressed() {
        print("TEAM 2 BUTTON PRESSED!")
    }

}


// MARK: - UICollectionView DataSource and Delegate methods

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
            self.slideGameViews(direction: .Left)
        case gameRosterCollectionView:
            if let cell = gameRosterCollectionView.cellForItemAtIndexPath(indexPath) as? GameRosterCell {
                cell.willAddPlayer = !cell.willAddPlayer
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
        
        if kind == UICollectionElementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "idCellHeaderGameInfo", forIndexPath: indexPath) as! GameInfoHeaderView
            headerView.teamButton1.addTarget(self, action: #selector(self.teamButton1Pressed), forControlEvents: .TouchUpInside)
            headerView.teamButton2.addTarget(self, action: #selector(self.teamButton2Pressed), forControlEvents: .TouchUpInside)
            return headerView
        } else {
            
            let footerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: "idFooterGameRoster", forIndexPath: indexPath)
            return footerView
        }
        
    }
    

}


// MARK: - UICollectionView Delegate Flow Layout

extension GameViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let cellWidth: CGFloat = self.view.bounds.width - 15.0
        let cellHeight: CGFloat = 70.0
        return CGSize(width: cellWidth, height: cellHeight)
    }
}





