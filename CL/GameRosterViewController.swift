//
//  GameRosterViewController.swift
//  CL
//
//  Created by iwritecode on 12/6/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//
//
//import UIKit
//
//class GameRosterViewController: UIViewController {
//    
//    var roster = players
//    
//    var selectedIndexPath = NSIndexPath()
//    var deselectedIndexPath = NSIndexPath()
//    var hasBeenSelected: Bool = false
//    
//    @IBOutlet weak var gameRosterCollectionView: UICollectionView!
//    
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//        
//        configureViews()
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    func configureViews() {
//        registerCells()
//    }
//    
//    func registerCells() {
//        gameRosterCollectionView.registerNib(UINib(nibName: "GameRosterCell", bundle: nil), forCellWithReuseIdentifier: "idCellGameInfo")
//    }
//    
//    
//}
//
//extension GameRosterViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    
//    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return players.count
//    }
//    
//    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        let cell = gameRosterCollectionView.dequeueReusableCellWithReuseIdentifier("idCellGameRoster", forIndexPath: indexPath) as! GameRosterCell
//        let player = players[indexPath.row]
//        cell.number = player.number
//        cell.playerName = player.name
////        cell.teamName = player.teamName
////        cell.cost = "\(player.cost)"
//        return cell
//    }
//    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        let padding: CGFloat = 15.0
//        let cellWidth = self.view.bounds.width - padding
//        let cellHeight: CGFloat = 68.0
//        return CGSize(width: cellWidth, height: cellHeight)
//    }
//
//    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        self.selectedIndexPath = indexPath
//    }
//    
//    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
//        self.deselectedIndexPath = indexPath
//    }
//    
//    
//}
