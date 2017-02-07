//
//  GameViewController.swift
//  CL
//
//  Created by iwritecode on 12/5/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//

import Firebase
import UIKit
import SwiftLoader





// MARK: - GameViewController
class GameViewController: UIViewController, MainViewDelegate {
    
    

    // MARK: Game properties
    
//    var game = Game() //Z: not used
    var selectedGame: Game? = nil
    var games = [Game]()
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
        
        
//        for game in self.games {
//            print(game.category)
//            print(game.venue)
//            print(game.gameID)
//            print(game.latitude)
//            print(game.longitude)
//            print(game.team1.name)
//            print(game.team1.players)
//            print(game.team2.name)
//            print(game.team2.players)
//            print("\n")
//        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        let mainVC = parent as! MainViewController
        mainVC.delegate = self
        
    }
    override func viewDidAppear(_ animated: Bool) {

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Data Retrieval
    
    //Z: I commented this out - not sure what it's used for
//    func categoryString(_ category: CategoryType) -> String {
//        switch category {
//        case .mlb:
//            return "mlb"
//        case .mls:
//            return "mls"
//        case .ncaaBasketball:
//            return "ncaa-basketball"
//        case .ncaaFootball:
//            return "ncaa-football"
//        case .nba:
//            return "nba"
//        case .nfl:
//            return "nfl"
//        case .nhl:
//            return "nhl"
//        }
//        
//    }

    
    func getGameDataFor(_ category: CategoryType, completion: @escaping (_ games: [Game]) -> ()) {
        
//        // Show acitivity indicator
//        self.showLoadingIndicator()
//        
//        let categoryName = categoryString(category)
//        
//        let gamesRef = FIRDatabase.database().reference().child("games").child("category").child(categoryName)
//        
//        gamesRef.observe(FIRDataEventType.value, with: { (snapshot) in
//            if !snapshot.exists() {
//                print("NO SNAPSHOT AVAILABLE")
//                self.hideLoadingIndicator()
//            } else {
//                
//                if let allKeys = (snapshot.value as AnyObject).allKeys as? [String] {
//                    
//                    for key in allKeys {
//                        
//                        if let currentGame = (snapshot.value! as AnyObject).value(forKey: key) {
//                            let gameData = Game()
//                            gameData.category = categoryName
//                            gameData.gameID = key
//                            gameData.venue = (currentGame as AnyObject).value(forKey: "venue")! as! String
//                            gameData.latitude = (currentGame as AnyObject).value(forKey: "latitude") as! Float
//                            gameData.longitude = (currentGame as AnyObject).value(forKey: "longitude") as! Float
//                            
//                            let dateString = (currentGame as AnyObject).value(forKey: "end-registration") as! String
//                            
//                            
//                            // GET TEAM 1 INFO
//                            
//                            if let team1 = (currentGame as AnyObject).value(forKey: "team1") as? NSMutableDictionary {
//                                
//                                print(team1.allKeys)
//                                
//                                if let teamname = team1.value(forKey: "teamname") as? String {
//                                    gameData.team1.name = teamname
//                                }
//                                
//                                if let players = team1.value(forKey: "players") as? NSMutableDictionary {
//                                    var playerKeys = [String]()
//                                    
//                                    for player in players {
//                                        playerKeys.append(player.key as! String)
//                                        
//                                        if let playerInfo = player.value as? NSDictionary {
//                                            var playerObject = Player()
//                                            playerObject.name = playerInfo.value(forKey: "name") as! String
//                                            playerObject.pointValue = playerInfo.value(forKey: "point-value") as! Float
//                                            playerObject.number = playerInfo.value(forKey: "number") as! Int
//                                            gameData.team1.players += [playerObject]
//                                        }
//                                    }
//                                    
//                                }
//                            }
//                            
//                            
//                            // GET TEAM 2 INFO
//                            if let team2 = (currentGame as AnyObject).value(forKey: "team2") as? NSMutableDictionary {
//                                
//                                // Get team 2 name
//                                if let teamname = team2.value(forKey: "teamname") as? String {
//                                    gameData.team2.name = teamname
//                                }
//                                
//                                // Get team 2 players
//                                if let players2 = team2.value(forKey: "players") as? NSMutableDictionary {
//                                    var playerKeys = [String]()
//                                    
//                                    for player in players2 {
//                                        playerKeys.append(player.key as! String)
//                                        
//                                        if let playerInfo = player.value as? NSDictionary {
//                                            var playerObject = Player()
//                                            playerObject.name = playerInfo.value(forKey: "name") as! String
//                                            playerObject.pointValue = playerInfo.value(forKey: "point-value") as! Float
//                                            playerObject.number = playerInfo.value(forKey: "number") as! Int
//                                            gameData.team2.players += [playerObject]
//                                        }
//                                    }
//                                    
//                                }
//                            }
//                            self.games.append(gameData)
//                        }
//                    }
//                    
//                    completion(self.games)
//                    
//                    // Hide activity indicator
//                    DispatchQueue.main.async(execute: { 
//                        self.hideLoadingIndicator()
//                    })
//                    
//                } else {
//                    print("Could not map data")
//                }
//            }
//            
//        })
        
    }
    
    
    // MARK: UI Functions
    
    func hideLoadingIndicator() {
        SwiftLoader.hide()
    }
    
    func showLoadingIndicator() {
        var config: SwiftLoader.Config = SwiftLoader.Config()
        config.size = 50
        config.spinnerColor = UIColor.black
        config.foregroundColor = UIColor.lightGray
        config.foregroundAlpha = 0.7
        config.backgroundColor = UIColor.white
        config.cornerRadius = 5.0
        SwiftLoader.setConfig(config)
        SwiftLoader.show(animated: true)
    }

    
    func registerCells() {
        // GAME CollectionViews
        gameMatchupCollectionView.register(UINib(nibName: "GameMatchupCell", bundle: nil), forCellWithReuseIdentifier: "idCellGameMatchup")
        gameRosterCollectionView.register(UINib(nibName: "GameRosterCell", bundle: nil), forCellWithReuseIdentifier: "idCellGameInfo")
        
        gameRosterCollectionView.register(UINib(nibName: "GameRosterCollectionFooter", bundle: nil), forCellWithReuseIdentifier: "idFooterGameRoster")
        
//        gameRosterCollectionView.register(UINib(nibName: "GameInfoHeaderView", bundle: nil), forCellWithReuseIdentifier: "idCellHeaderGameInfo")
    }
    
    
    func setGameRosterViewState() {
        if let mainVC = self.parent as? MainViewController {
            mainVC.gameRosterViewIsActive = self.gameRosterViewIsActive
        }
    }

    func slideGameViews(direction: Direction) {
        switch direction {
        case .right:
            UIView.animate(withDuration: 0.2, animations: {
                self.gameRosterViewCenterX.constant += self.view.bounds.width
                self.gameMatchupViewCenterX.constant += self.view.bounds.width
                self.view.layoutIfNeeded()
                self.gameRosterViewIsActive = false
                
                if let mainVC = self.parent as? MainViewController {
                    mainVC.cancelButton.hide()
                }
            }) 
        case .left:
            UIView.animate(withDuration: 0.2, animations: {
                self.gameRosterViewCenterX.constant -= self.view.bounds.width
                self.gameMatchupViewCenterX.constant -= self.view.bounds.width
                self.view.layoutIfNeeded()
                self.gameRosterViewIsActive = true
                
                if let mainVC = self.parent as? MainViewController {
                    mainVC.cancelButton.show()
                }
            }) 
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == gameMatchupCollectionView {
            // let matchup = GameMatchups[indexPath.row]

            let cell = gameMatchupCollectionView.dequeueReusableCell(withReuseIdentifier: "idCellGameMatchup", for: indexPath) as! GameMatchupCell

            let game = games[indexPath.row]
            cell.homeTeam = game.team1.name
            cell.awayTeam = game.team2.name
            cell.venue = game.venue
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, yyyy"
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "h:mm a"
            
            if let safeDate = game.endRegistration{
                cell.date = dateFormatter.string(from: safeDate)
                cell.time = timeFormatter.string(from: safeDate)

            }

      
            
//            self.getGameDataFor(.nba, completion: { (games) in
//                var game = games[indexPath.row]
//                cell.homeTeam = game.team1.name
//                cell.awayTeam = game.team2.name
//                cell.venue = game.venue
//                cell.date = "\(game.endRegistration)"
//                
//            })
            
//            cell.awayTeam = matchup.awayTeam
//            cell.homeTeam = matchup.homeTeam
//            cell.venue = matchup.venue
//            cell.date = matchup.date
//            cell.time = matchup.time
            
            return cell
        } else {
            let cell = gameRosterCollectionView.dequeueReusableCell(withReuseIdentifier: "idCellGameRoster", for: indexPath) as! GameRosterCell
            
            let safeCount = self.selectedGame?.team1.players.count ?? 0
            
            
            if indexPath.row < safeCount {
                let player = self.selectedGame?.team1.players[indexPath.row]
                cell.number = player?.number ?? 0 //Seth: is there a better way to fix this?
                cell.playerName = player?.name ?? ""
                cell.teamName = self.selectedGame?.team1.name ?? ""
                let pointValue = player?.pointValue ?? 0
                cell.cost = String(describing: Int(pointValue)) //Seth: is there a reason that pointValue is a float?
            }else{
                let player = self.selectedGame?.team2.players[(indexPath.row - safeCount)]
                cell.number = player?.number ?? 0 //Seth: is there a better way to fix this?
                cell.playerName = player?.name ?? ""
                cell.teamName = self.selectedGame?.team2.name ?? ""
                let pointValue = player?.pointValue ?? 0
                cell.cost = String(describing: Int(pointValue))
            }
//            let player = self.selectedGame?.team1.players[indexPath.row]
//            cell.number = player.number ?? 0 //Seth: is there a better way to fix this?
//            cell.playerName = player.name ?? ""

//            cell.teamName = player.teamName
//            cell.cost = "\(player.cost)"
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
            
        case gameMatchupCollectionView:
            self.selectedGame = self.games[indexPath.row]
            self.gameRosterCollectionView.reloadData()
            
            self.slideGameViews(direction: .left)
        case gameRosterCollectionView:
            if let cell = gameRosterCollectionView.cellForItem(at: indexPath) as? GameRosterCell {
                cell.willAddPlayer = !cell.willAddPlayer
            }
        default:
            break
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // Adjust count to include game information cell on first row
        
        if collectionView == gameMatchupCollectionView {
            return self.games.count
        } else {
            let team1Count = self.selectedGame?.team1.players.count ?? 0
            let team2Count = self.selectedGame?.team2.players.count ?? 0
            let totalPlayers = team1Count + team2Count
            return totalPlayers
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "idCellHeaderGameInfo", for: indexPath) as! GameInfoHeaderView
            headerView.teamButton1.addTarget(self, action: #selector(self.teamButton1Pressed), for: .touchUpInside)
            headerView.teamButton2.addTarget(self, action: #selector(self.teamButton2Pressed), for: .touchUpInside)
//            headerView.team1 = "Test"
            
            if let safeGame = self.selectedGame{
                headerView.configureHeader(game: safeGame)
            }
            return headerView
        } else {
            
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "idFooterGameRoster", for: indexPath)
            return footerView
        }
        
    }
    
    func updateList() {
        gameMatchupCollectionView.reloadData()
    }
    
    func updateGameDone(games: [Game], sender : UIViewController){
        self.games = games
        self.updateList()
    }

}


// MARK: - UICollectionView Delegate Flow Layout

extension GameViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat = self.view.bounds.width - 15.0
        let cellHeight: CGFloat = 70.0
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
}





