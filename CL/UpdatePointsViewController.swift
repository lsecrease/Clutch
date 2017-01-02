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
    
    let teamName1 = "Chicago Bulls"
    let teamName2 = "Miami Heat"
    
    var team1 = Team()
    var team2 = Team()
    var startIndex1: Int!
    var startIndex2: Int!

    
    var hideTeamRows1 = true
    
    // MARK: Test Data
    
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
    
    
    // MARK: View life-cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTeams()
        configureFormAppearance()
        
        startIndex1 = 1
        startIndex2 = self.players1.count + 2
        
        form +++ Section() { Section in
            Section.tag = "MainSection"
            Section.header = HeaderFooterView<UIView>(HeaderFooterProvider.Class)
            Section.header?.height = { 0.5 }
            }
            
        <<< UpdateTeamRow() { row in
            row.teamName = teamName1
            row.tag = "UpdateTeamRow1"
            self.addTeam1()
        }.onCellSelection({ (cell, row) in
            row.value = !row.value!
        })
            
        addTeam1()
        
         form.last! <<< UpdateTeamRow() { row in
                row.teamName = teamName2
                row.tag = "UpdateTeamRow2"
        }.onCellSelection({ (cell, row) in
            row.value = !row.value!
        })
        
        addTeam2()
        
    }
    
    // MARK: Custom table functions
    
    func configureFormAppearance() {
        self.tableView?.separatorStyle = .None
        
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
    
    
    // MARK: Data loading
    
    func addTeam1() {
        
        if let mainSection = self.form.sectionByTag("MainSection") {
            if team1.players != nil {
                var index = 1
                for player in team1.players! {
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
    
    func addTeam2() {
        
        if let mainSection = self.form.sectionByTag("MainSection") {
            if team1.players != nil {
                var index = 1
                for player in team2.players! {
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
    
    func configureForm() {
        
    }
    
    func customizeFormAppearance() {
        
    }
    
}
