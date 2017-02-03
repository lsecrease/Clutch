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
    
    var team1 = Team()
    var team2 = Team()
    
    var game = Game()
    
    // Firebase
    var ref : FIRDatabaseReference?
    
    // MARK: View life-cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        printAllData()
        
        customizeFormAppearance()
        
        form +++ Section() { Section in
            Section.tag = "MainSection"
            Section.header = HeaderFooterView<UIView>(HeaderFooterProvider.class)
            Section.header?.height = { 0.5 }
            }
            
        <<< UpdateTeamRow() { row in
            row.teamName = team1.name
            row.tag = "UpdateTeamRow1"
            self.addTeam1()
        }.onCellSelection({ (cell, row) in
            row.value = !row.value!
        })
            
        addTeam1()
        
         form.last! <<< UpdateTeamRow() { row in
                row.teamName = team2.name
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
        
        print("\nGAME INFO:-\n")
        print("CATEGORY: \(self.game.category)")
        print("TEAM 1: \(game.team1.name)")
        print("TEAM 1 PLAYERS: \(game.team1.players)")
        print("TEAM 2: \(game.team2.name)")
        print("TEAM 2 PLAYERS: \(game.team2.players)")
        print("STARTING VALUE: \(game.startingValue)")
        print("VENUE: \(game.venue)")
        
    }
    
    
    // MARK: Data loading
    
    // Function to add 1st team
    
    func addTeam1() {
        
        if let mainSection = self.form.sectionBy(tag: "MainSection") {
            if team1.players.count > 0 {
                var index = 1
                for player in team1.players {
                    guard let playerID = player.playerID else { continue }
//                    weak var weakSelf = self
                    let newRow = UpdatePlayerPointsRow() {(row) in
                        row.name = player.name ?? ""
                        row.pointValue = player.score ?? 0
                        
                        row.hidden = .function(["UpdateTeamRow1"], { form -> Bool in
                            let row: RowOf<Bool>! = form.rowBy(tag: "UpdateTeamRow1")
                            return row.value ?? true == true
                        })
                        
                        }.onChange({ (row) in
                            print(playerID)
//                            if var player = weakSelf?.team1.playerForPlayerID(playerId: playerID) {
                            if var player = self.team1.playerForPlayerID(playerId: playerID) {
                                if let safeIndex = self.team1.players.index(of: player){
                                    if row.value != nil {
                                        //                                    player.score = row.value
                                        self.game.team1.players[safeIndex].score = row.value
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
        
        if let mainSection = self.form.sectionBy(tag: "MainSection") {
            if team1.players.count > 0 {
                var index = 1
                for player in team2.players {
                    let newRow = UpdatePlayerPointsRow() { row in
                        row.name = player.name ?? ""
                        row.pointValue = player.score ?? 0
                        row.hidden = .function(["UpdateTeamRow2"], { form -> Bool in
                            let row: RowOf<Bool>! = form.rowBy(tag: "UpdateTeamRow2")
                            return row.value ?? true == true
                            })
                        
                        }.onChange({ (row) in
//                            print(player.name ?? "nope")
//                            if row.value != nil {
//                                player.score = row.value
//                            }
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
        //ToDo: Save score to FB
        self.addScoresToDatabase()
        
        //ToDo: Create ranking among participants
        //ToDo:
    }
    func addScoresToDatabase(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        self.ref = FIRDatabase.database().reference()
        var childUpdates : [String: AnyObject] = [:]
        
        if let safeDate = self.game.gameStartTime{
            let gameDate = dateFormatter.string(from: safeDate)
            for player in team1.players{
                guard let safePlayerId = player.playerID else {return}

                childUpdates["/games/\(gameDate)/\(self.game.gameID)/team1/players/\(safePlayerId)/score"] = player.score as AnyObject?
            }
            for player in team2.players{
                guard let safePlayerId = player.playerID else {return}

                childUpdates["/games/\(gameDate)/\(self.game.gameID)/team2/players/\(safePlayerId)/score"] = player.score as AnyObject?
            }
            self.ref?.updateChildValues(childUpdates)

        }

        
    }

    
}
