//
//  GameListViewController.swift
//  CL
//
//  Created by Zachary Hein on 2/2/17.
//  Copyright © 2017 iwritecode. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import FBSDKCoreKit
import FBSDKLoginKit

enum GameListSections: Int {
    case activeGamesSection = 0
    case completedGamesSection
}

class GameListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: - Life Cycle Methods
    @IBOutlet weak var tableView: UITableView!
    
    var ref : FIRDatabaseReference?
    var gamesRef : UInt?
    
    var allGames = [Game]()
    
    // Team 1
    var playerForTeam1: Player!
    var playersForTeam1 = [Player]()
    
    // Team 2
    var playerForTeam2: Player!
    var playersForTeam2 = [Player]()

    
    var activeGames : [Game] = []
    var completedGames : [Game] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ref = FIRDatabase.database().reference()
        self.updateGames()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var currentGame = Game()
        
        if let safeIndexPath = tableView.indexPathForSelectedRow {
            
            switch safeIndexPath.section{
            case GameListSections.completedGamesSection.rawValue:
                currentGame = completedGames[(safeIndexPath as NSIndexPath).row]
            case GameListSections.activeGamesSection.rawValue:
                currentGame = activeGames[(safeIndexPath as NSIndexPath).row]
            default:
                return
            }
        }
        
        
        if segue.identifier == "updatePointsSegue" {
            if let updatePointsVC = segue.destination as? UpdatePointsViewController{
                updatePointsVC.game = currentGame
                updatePointsVC.team1 = currentGame.team1
                updatePointsVC.team2 = currentGame.team2
                
            }
        }
    }
    
    
    // MARK: UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case GameListSections.activeGamesSection.rawValue:
            return self.activeGames.count
        case GameListSections.completedGamesSection.rawValue:
            return self.completedGames.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath as NSIndexPath).section{
        case GameListSections.activeGamesSection.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as? GameCell else {
                return UITableViewCell()
            }
            cell.configureCell(game: self.activeGames[indexPath.row])
            cell.tapAction = { _ in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                
                self.ref = FIRDatabase.database().reference()
                var childUpdates : [String: AnyObject] = [:]
                
                let currentGame = self.activeGames[indexPath.row]
                if let safeDate = currentGame.gameStartTime{
                    let endDate = NSDate()
                    let gameDate = dateFormatter.string(from: safeDate)
                    childUpdates["/games/\(gameDate)/\(currentGame.gameID)/endGameTime"] = String(describing: endDate) as AnyObject?
                    self.ref?.updateChildValues(childUpdates)

                }
                
                self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableViewScrollPosition.none)
                return self.performSegue(withIdentifier: "updatePointsSegue", sender: self)

                
                
            }
            
            return cell
            
        case GameListSections.completedGamesSection.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as? GameCell else {
                return UITableViewCell()
            }
            cell.configureCell(game: self.completedGames[indexPath.row])
            
            return cell
        default:
            return UITableViewCell()
        }
    }

    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case GameListSections.activeGamesSection.rawValue:
            return "Active Games"
        case GameListSections.completedGamesSection.rawValue:
            return "Completed Games"
        default:
            return ""
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath as NSIndexPath).section{
        case GameListSections.completedGamesSection.rawValue:
            print("completed games")

            return self.performSegue(withIdentifier: "updatePointsSegue", sender: self)
            
        default:
            return
        }
    }

    
    // MARK: - Actions
    @IBAction func addButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "createGameSegue", sender: self)
    }
    @IBAction func logoutButtonPressed(_ sender: Any) {
        // log out here
        
        try! FIRAuth.auth()!.signOut()
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        
        self.navigationController?.dismiss(animated: true, completion: nil)

    }
    
    // MARK: - Custom methods
    func updateList() {
        tableView.reloadData()
    }
    func updateGames(){
        ref = ref?.child("games")
        let gamessQuery = ref?.queryLimited(toLast: 25) //Seth: how were we going to do this?
        //addAsyncLoad() do we need this?
        
        gamesRef = gamessQuery?.observe(.value, with: { (snapshot) in
            if let games = snapshot.value as? [String : AnyObject] {
                
                self.allGames = [] // clear allGames dictionary
                
                //save games
                for gameByDate in games{
                    if let gameByID = gameByDate.1 as? [String:AnyObject]{
                        for game in gameByID{
                            let currentGame = Game(gameDict: game)
                                self.allGames.append(currentGame)
                        }
                    }
                }
                
                //clear out id arrays
                self.activeGames = []
                self.completedGames = []
                
                for game in self.allGames{
                    if game.endGameTime == nil{
                        self.activeGames.append(game)
                    }else{
                        self.completedGames.append(game)
                    }
                }
                //sort by date
                self.activeGames.sort(by: {
                    guard let safeFirstStartDate = $0.gameStartTime, let safeSecondStartDate = $1.gameStartTime else { return true }
                    
                    return safeFirstStartDate.compare(safeSecondStartDate) == .orderedAscending
                })
                self.completedGames.sort(by: {
                    guard let safeFirstStartDate = $0.gameStartTime, let safeSecondStartDate = $1.gameStartTime else { return true }
                    
                    return safeFirstStartDate.compare(safeSecondStartDate) == .orderedAscending
                })

                
            }
            self.updateList()
        })
    }
}
