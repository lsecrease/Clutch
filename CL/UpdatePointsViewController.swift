//
//  UpdatePointsViewController.swift
//  CL
//
//  Created by iwritecode on 12/21/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//

import UIKit
import Eureka

// MARK: - UpdatePointsViewController

class UpdatePointsViewController: FormViewController {
    
    // MARK: Properties
    
    var team1 = Team()
    var team2 = Team()
    
    var game = Game()
    
    // MARK: View life-cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        printAllData()
        
        customizeFormAppearance()
        
        form +++ Section() { Section in
            Section.tag = "MainSection"
            Section.header = HeaderFooterView<UIView>(HeaderFooterProvider.Class)
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
        self.tableView?.separatorStyle = .None
        
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
        
        if let mainSection = self.form.sectionByTag("MainSection") {
            if team1.players.count > 0 {
                var index = 1
                for player in team1.players {
                    let newRow = UpdatePlayerPointsRow() { row in
                        row.name = player.name
                        row.pointValue = player.pointValue
                        row.hidden = .Function(["UpdateTeamRow1"], { form -> Bool in
                            let row: RowOf<Bool>! = form.rowByTag("UpdateTeamRow1")
                            return row.value ?? true == true
                        })

                    }
                    form.last! <<< newRow
                    index += 1
                }
            }
            mainSection.reload()
        }
    }
    
    // Function to add 2nd team
    
    func addTeam2() {
        
        if let mainSection = self.form.sectionByTag("MainSection") {
            if team1.players.count > 0 {
                var index = 1
                for player in team2.players {
                    let newRow = UpdatePlayerPointsRow() { row in
                        row.name = player.name
                        row.pointValue = player.pointValue
                        row.hidden = .Function(["UpdateTeamRow2"], { form -> Bool in
                            let row: RowOf<Bool>! = form.rowByTag("UpdateTeamRow2")
                            return row.value ?? true == true
                        })
                        
                    }
                    form.last! <<< newRow
                    index += 1
                }
            }
            mainSection.reload()
        }
        
    }
    
    // MARK: IBAction methods
    
    @IBAction func doneButtonPressed(sender: UIBarButtonItem) {
        
    }
    
}
