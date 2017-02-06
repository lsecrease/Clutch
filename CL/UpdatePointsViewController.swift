//
//  UpdatePointsViewController.swift
//  CL
//
//  Created by iwritecode on 12/21/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//

import Firebase
import Eureka
import UIKit


// MARK: - UpdatePointsViewController

class UpdatePointsViewController: FormViewController {
    
    // MARK: Properties    
    var game : Game?
    
    // Firebase
    var ref : FIRDatabaseReference?
    
    // MARK: View life-cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let safeGame = self.game else {return}

        printAllData()
        
        customizeFormAppearance()
        
        form +++ Section() { Section in
            Section.tag = "MainSection"
            Section.header = HeaderFooterView<UIView>(HeaderFooterProvider.class)
            Section.header?.height = { 0.5 }
            }
            
        <<< UpdateTeamRow() { row in
            row.teamName = safeGame.team1.name
            row.tag = "UpdateTeamRow1"
            self.addTeam1()
        }.onCellSelection({ (cell, row) in
            row.value = !row.value!
        })
            
        addTeam1()
        
         form.last! <<< UpdateTeamRow() { row in
                row.teamName = safeGame.team2.name
                row.tag = "UpdateTeamRow2"
        }.onCellSelection({ (cell, row) in
            row.value = !row.value!
        })
        
        addTeam2()
        
    }
    
    
    // MARK: Custom table functions
    
    func customizeFormAppearance() {
        self.tableView?.separatorStyle = .none
        self.tableView?.backgroundColor = UIColor.white
    }
    
    
    // Test data
        func printAllData() {
        guard let safeGame = self.game else {return}

        print("\nGAME INFO:-\n")
        print("CATEGORY: \(safeGame.category)")
        print("TEAM 1: \(safeGame.team1.name)")
        print("TEAM 1 PLAYERS: \(safeGame.team1.players)")
        print("TEAM 2: \(safeGame.team2.name)")
        print("TEAM 2 PLAYERS: \(safeGame.team2.players)")
        print("STARTING VALUE: \(safeGame.startingValue)")
        print("VENUE: \(safeGame.venue)")
        
    }
    
    
    // MARK: Data loading
    
    // Function to add 1st team
    
    func addTeam1() {
        guard let safeGame = self.game else {return}

        if let mainSection = self.form.sectionBy(tag: "MainSection") {
            if team1.players.count > 0 {
                var index = 1
                for player in safeGame.team1.players {
                    guard let playerID = player.playerID else { continue }
                    let newRow = UpdatePlayerPointsRow() {(row) in
                        row.name = player.name ?? ""
                        row.pointValue = player.score ?? 0
                        
                        row.hidden = .function(["UpdateTeamRow1"], { form -> Bool in
                            let row: RowOf<Bool>! = form.rowBy(tag: "UpdateTeamRow1")
                            return row.value ?? true == true
                        })
                        
                        }.onChange({ (row) in
                            // player.score = row.value wouldn't store data properly because of being inside a block
                            if let player = safeGame.team1.playerForPlayerID(playerId: playerID) {
                                if let safeIndex = safeGame.team1.players.index(of: player){
                                    if row.value != nil {
                                        safeGame.team1.players[safeIndex].score = row.value
                                    }
                                }
                            }
                        })
                    form.last! <<< newRow
                    index += 1
                }
            }
            mainSection.reload()
        }
    }
    
    // Function to add 2nd team
    
    func addTeam2() {
        guard let safeGame = self.game else {return}

        if let mainSection = self.form.sectionBy(tag: "MainSection") {
            if team1.players.count > 0 {
                var index = 1
                for player in safeGame.team2.players {
                    guard let playerID = player.playerID else { continue }
                    let newRow = UpdatePlayerPointsRow() { row in
                        row.name = player.name ?? ""
                        row.pointValue = player.score ?? 0
                        row.hidden = .function(["UpdateTeamRow2"], { form -> Bool in
                            let row: RowOf<Bool>! = form.rowBy(tag: "UpdateTeamRow2")
                            return row.value ?? true == true
                            })
                        
                        }.onChange({ (row) in
                            // player.score = row.value wouldn't store data properly because of being inside a block
                            if let player = safeGame.team2.playerForPlayerID(playerId: playerID) {
                                if let safeIndex = safeGame.team2.players.index(of: player){
                                    if row.value != nil {
                                        safeGame.team2.players[safeIndex].score = row.value
                                    }
                                }
                            }
                        })
                    form.last! <<< newRow
                    index += 1
                }
            }
            mainSection.reload()
        }
        
    }
    
    // MARK: IBAction methods
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        self.addScoresToDatabase()
        self.updateUserScores()
        self.createRanking()
        
        let _ = self.navigationController?.popViewController(animated: true)
    }
    func addScoresToDatabase(){
        guard let safeGame = self.game else {return}

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        self.ref = FIRDatabase.database().reference()
        var childUpdates : [String: AnyObject] = [:]
        
        
        if let safeDate = safeGame.gameStartTime{
            let gameDate = dateFormatter.string(from: safeDate)
            for player in safeGame.team1.players{
                guard let safePlayerId = player.playerID else {return}

                childUpdates["/games/\(gameDate)/\(safeGame.gameID)/team1/players/\(safePlayerId)/score"] = player.score as AnyObject?
            }
            for player in safeGame.team2.players{
                guard let safePlayerId = player.playerID else {return}

                childUpdates["/games/\(gameDate)/\(safeGame.gameID)/team2/players/\(safePlayerId)/score"] = player.score as AnyObject?
            }
            self.ref?.updateChildValues(childUpdates)
        }
    }
    func updateUserScores(){
        guard let safeGame = self.game else {return}

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        var childUpdates : [String: AnyObject] = [:]

        if let safeDate = safeGame.gameStartTime{
            let gameDate = dateFormatter.string(from: safeDate)
            
            for user in safeGame.participants{
                var userScore: Float = 0.0
                for playerId in user.roster{
                    if let thisPlayer = safeGame.team1.players.filter ({$0.playerID == playerId}).first {
                        if let safeScore = thisPlayer.score{
                            userScore += safeScore
                        }
                        continue
                    }
                    
                    if let thisPlayer = safeGame.team2.players.filter ({$0.playerID == playerId}).first {
                        if let safeScore = thisPlayer.score{
                            userScore += safeScore
                        }
                    }
                }
                if let safeUserId = user.userId{
                    childUpdates["/games/\(gameDate)/\(safeGame.gameID)/participants/\(safeUserId)/score"] = userScore as AnyObject?
                }
                user.score = userScore
            }
            //update Firebase
            self.ref?.updateChildValues(childUpdates)
        }
    }
    func createRanking(){
        guard let safeGame = self.game else {return}
        
        //filter out disqualified participants
        var participants = safeGame.participants.filter ({
            
            if let isDisqualified = $0.disqualified{
                return !isDisqualified
            }
            
            return false
        })
        
        //sort scores by hi-low
        participants = participants.sorted(by: {
            guard let firstScore = $0.score, let secondScore = $1.score else{
                return true
            }
            
        return firstScore > secondScore
        })
        
        //map Ids
        let rankedIds = participants.map { (User) -> String in
            User.userId!
        }
        
        //save to Firebase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        self.ref = FIRDatabase.database().reference()
        var childUpdates : [String: AnyObject] = [:]
        if let safeDate = safeGame.gameStartTime{
            let gameDate = dateFormatter.string(from: safeDate)
            childUpdates["/games/\(gameDate)/\(safeGame.gameID)/ranking"] = rankedIds as AnyObject?
        }
        self.ref?.updateChildValues(childUpdates)
    }

    
}
