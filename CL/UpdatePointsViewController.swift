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
    
    let teamName1 = "Chicago Bulls"
    let teamName2 = "Miami Heat"
    
    var team1 = Team()
    var team2 = Team()
    var startIndex1: Int!
    var startIndex2: Int!

    
    var hideTeamRows1 = true
    
    let players1: [Player] = [
        Player(name: "Michael Jordan", number: "23", pointValue: 1000),
        Player(name: "Scottie Pippen", number: "33", pointValue: 650),
        Player(name: "Dennis Rodman", number: "91", pointValue: 600)
    ]
    
    let players2: [Player] = [
        Player(name: "Lebron James", number: "6", pointValue: 1000),
        Player(name: "Dwayne Wade", number: "3", pointValue: 700),
        Player(name: "Chris Andersen", number: "11", pointValue: 650)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTeams()
        configureFormAppearance()
        
        startIndex1 = 1
        startIndex2 = self.players1.count + 2
        
        form +++ Section() { Section in
                Section.tag = "MainSection"
                Section.header?.height = { 0 }
                addTeam1()
            }
            
        <<< UpdateTeamRow("UpdateTeamRow1") { row in
            row.teamName = teamName1

        }.onCellSelection({ (cell, row) in
            
            if self.team1.players != nil {
                let allRows = self.form.allRows
                let startIndex = 1
                if row.value == true {
                } else {
                    for i in startIndex..<self.team1.players!.count {
                        allRows[i].hidden = true
                    }
                }
            }

        })
            
//        <<< UpdatePlayerPointsRow("UpdatePlayerPointsRow") { row in
//            row.name = "Devin Thomas"
//            row.pointValue = 50
//            row.hidden = true
//            row.evaluateHidden()
//        }
//            
//        <<< UpdateTeamRow() { row in
//            row.teamName = teamName2
//        }
        
        addTeam1()
        
    }
    
    func configureFormAppearance() {
        self.tableView?.separatorStyle = .None
        
        UpdatePlayerPointsRow.defaultCellUpdate = { cell, row in
            row.hidden = true
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func loadForm() {
        customizeFormAppearance()
    }
    
    
    // Temporary functions
    func createTeams() {
        team1.name = "Wake Forest University"
        team1.players = players1
        
        team2.name = "Duke"
        team2.players = players2
        
    }
    
    func addTeam1() {
        
        if var mainSection = self.form.sectionByTag("MainSection") {
            if team1.players != nil {
                var index = 1
                for player in team1.players! {
                    let newRow = UpdatePlayerPointsRow() { row in
                        row.name = player.name
                        row.pointValue = player.pointValue
                        row.hidden = true
                    }
                    form.last! <<< newRow
                    index += 1
                }
            }
            mainSection.reload()
        }
    }
    
    func addTeam2() {
        
        print("Add team 2 called")
        
        if var mainSection = self.form.sectionByTag("MainSection") {
            if team2.players != nil {
                var index = team1.players!.count + 5
                
                for player in team2.players! {
                    let newRow = UpdatePlayerPointsRow() { row in
                        row.name = player.name
                        row.pointValue = player.pointValue
                        row.hidden = true
                    }
                    form.last! <<< newRow
                    index += 1
                }
            }
            mainSection.reload()
        }
        
    }
    
    func configureForm() {
        
    }
    
    func customizeFormAppearance() {
        
    }
    
}
