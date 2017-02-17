//
//  LiveViewController.swift
//  CL
//
//  Created by iwritecode on 12/24/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//

import Firebase
import UIKit


class LiveViewController: UIViewController, ChildViewProtocol {
    
    @IBOutlet weak var liveTeamView: UIView!
    @IBOutlet weak var liveTeamViewCenterX: NSLayoutConstraint!
    @IBOutlet weak var leaderboardView: UIView!
    @IBOutlet weak var leaderboardViewCenterX: NSLayoutConstraint!
    
    @IBOutlet weak var liveTeamCollectionView: UICollectionView!
    @IBOutlet weak var leaderboardCollectionView: UICollectionView!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var totalPointsLabel: UILabel!
    @IBOutlet weak var rankLabel2: UILabel!
    @IBOutlet weak var totalPointsLabel2: UILabel!
    
    @IBOutlet weak var leaderboardButton: UIButton!
    @IBOutlet weak var myTeamButton: UIButton!
    
    var games = [Game]()
    var liveGame: Game? = nil
    var selectedParticipant: User? = nil

    
    // Firebase database references
    var matchups = [(team1: Team, team2: Team)]()

    var ref : FIRDatabaseReference?


    // Cell Identifiers
    let idCellLeaderboard = "idCellLeaderboard"
    let idCellLiveTeam = "idCellLiveTeam"
    
    var liveTeamViewIsActive = true

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registerCells()
        
        
        // Position live views
        leaderboardViewCenterX.constant += self.view.bounds.width
        liveTeamViewCenterX.constant = self.view.bounds.origin.x

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setLiveTeamViewState()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }

    func showAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    /// MARK: IBActions
    
    @IBAction func bottomTabButtonPressed(_ sender: UIButton) {
        switch sender {
        case leaderboardButton:
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveLinear, animations: {
                self.liveTeamViewCenterX.constant -= self.view.bounds.width
                self.leaderboardViewCenterX.constant -= self.view.bounds.width
                self.view.layoutIfNeeded()
                self.liveTeamViewIsActive = false
                
                DispatchQueue.main.async(execute: {
                    if let mainVC = self.parent as? MainViewController {
                        mainVC.checkInbutton.hide()
                    }
                })

            }) { (finished) in
            }
        case myTeamButton:
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveLinear, animations: {
                self.liveTeamViewCenterX.constant += self.view.bounds.width
                self.leaderboardViewCenterX.constant += self.view.bounds.width
                self.view.layoutIfNeeded()
                self.liveTeamViewIsActive = true
                
                DispatchQueue.main.async(execute: { 
                    if let mainVC = self.parent as? MainViewController {
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
    
    
    // MARK: Custom functions
    
    func registerCells() {
        liveTeamCollectionView.register(UINib(nibName: "LiveTeamCell", bundle: nil), forCellWithReuseIdentifier: idCellLiveTeam)
        leaderboardCollectionView.register(UINib(nibName: "LeaderboardCell", bundle: nil), forCellWithReuseIdentifier: idCellLeaderboard)

    }
    
    func setLiveTeamViewState() {
        if let mainVC = self.parent as? MainViewController {
            mainVC.liveTeamViewIsActive = self.liveTeamViewIsActive
         }
    }

}


// MARK: - UiCollectionView DataSource and Delegate functions

extension LiveViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == liveTeamCollectionView {
           return self.selectedParticipant?.roster.count ?? 0
        } else {
            return liveGame?.rank.count ?? 0
        }
        
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView == liveTeamCollectionView {
            let cell = liveTeamCollectionView.dequeueReusableCell(withReuseIdentifier: idCellLiveTeam, for: indexPath) as! LiveTeamCell
            
            guard let safeGame = liveGame, let safeParticipant = self.selectedParticipant else{ return cell }
            let allPlayers: [Player] = safeGame.team1.players + safeGame.team2.players
            
            let currentPlayerID = safeParticipant.roster[indexPath.row]
            
            for player in allPlayers{
                if player.playerID == currentPlayerID{
                    // set player's information
                    cell.playerNumber = player.number ?? 0
                    cell.playerName = player.name ?? ""
                    
                    let score = player.score ?? 0
                    cell.playerPoint = String(describing: Int(score))
                
                    if safeGame.team1.players.contains(player){
                        cell.teamName = safeGame.team1.name
                    }else{
                        cell.teamName = safeGame.team2.name
                    }
                }
            }
            return cell

        } else {
            let cell = leaderboardCollectionView.dequeueReusableCell(withReuseIdentifier: idCellLeaderboard, for: indexPath) as! LeaderboardCell
            guard let safeRanking = self.liveGame?.rank, let safeUsers = self.liveGame?.participants, let safeCurrentUser = FIRAuth.auth()?.currentUser else { return cell }
            
            let rankedUserId = safeRanking[indexPath.row]
            
            let user = safeUsers.filter({$0.userId == rankedUserId}).first
            cell.rankLabel.text = "\(indexPath.row)"
            cell.usernameLabel.text = user?.name
            let userScore = user?.score ?? 0
            cell.pointsLabel.text = "\(Int(userScore))" + " pts"
            
            //set footer (total points and rank) values
            if safeCurrentUser.uid == user?.userId{
                self.totalPointsLabel.text = "\(Int(userScore))"
                self.rankLabel.text = "\(indexPath.row + 1)"
                self.totalPointsLabel2.text = "\(Int(userScore))"
                self.rankLabel2.text = "\(indexPath.row + 1)"
            }
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = liveTeamCollectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "idCellHeaderGameInfo", for: indexPath) as! GameInfoHeaderView

        if let safeGame = self.liveGame{
            headerView.configureHeader(game: safeGame)
        }
        return headerView
    }
    
    
    func updateGameData(allGames: [Game], activeGames: [Game], sender : UIViewController){
        self.games = allGames
        self.updateLiveGame()
    }
    
    func updateLiveGame(){
        guard let safeCurrentUser = FIRAuth.auth()?.currentUser else { return }
        
        
        // get the live game, if I am a participant, and if I have checked in, and if I am not disqualified
        self.liveGame = self.games.filter({
            
            if $0.participants.filter({$0.userId == safeCurrentUser.uid && $0.checkInTime != nil && $0.disqualified != true}).count > 0 {
                return true
            }
            
            return false
        
        }).first
        
        // get the participant that is me
        if let safeLiveGame = self.liveGame {
            for participant in safeLiveGame.participants {
   
                if participant.userId == safeCurrentUser.uid {
                    self.selectedParticipant = participant
                }
            }
        }
     
        self.updateList()
    }
    func updateList() {
        self.liveTeamCollectionView.reloadData()
        self.leaderboardCollectionView.reloadData()
    }
}


// MARK:- UICollectionView Delegate Flow Layout

extension LiveViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat = self.view.bounds.width - 15.0
        let cellHeight: CGFloat = 70.0
        return CGSize(width: cellWidth, height: cellHeight)
    }

}






