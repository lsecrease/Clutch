//
//  GameMatchupViewController.swift
//  CL
//
//  Created by iwritecode on 12/5/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//

import UIKit

class GameMatchupViewController: UIViewController {
    
    @IBOutlet weak var matchupCollectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        registerCells()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerCells() {
        matchupCollectionView.registerNib(UINib(nibName: "GameMatchupCell", bundle: nil), forCellWithReuseIdentifier: "idCellGameMatchup")
    }
    
}

// MARK: - UICollectionView DataSource, Delegate, Delegate Flow Layout

extension GameMatchupViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GameMatchups.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = matchupCollectionView.dequeueReusableCellWithReuseIdentifier("idCellGameMatchup", forIndexPath: indexPath) as! GameMatchupCell
        let matchup = GameMatchups[indexPath.row]
        cell.awayTeam = matchup.awayTeam
        cell.homeTeam = matchup.homeTeam
        cell.venue = matchup.venue
        cell.date = matchup.date
        cell.time = matchup.time
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let padding: CGFloat = 15.0
        let cellWidth = self.view.bounds.width - padding
        let cellHeight: CGFloat = 70.0
        let cellSize = CGSize(width: cellWidth, height: cellHeight)
        return cellSize
    }


}