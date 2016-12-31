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
    
    let team1: [Player] = [
        Player(name: "Michael Jordan", number: "23", pointValue: 1000),
        Player(name: "Scottie Pippen", number: "33", pointValue: 650),
        Player(name: "Dennis Rodman", number: "91", pointValue: 600)
    ]
    
    let team2: [Player] = [
        Player(name: "Lebron James", number: "6", pointValue: 1000),
        Player(name: "Dwayne Wade", number: "3", pointValue: 700),
        Player(name: "Chris Andersen", number: "11", pointValue: 650)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureFormAppearance()
        
        
        form +++ Section() { _ in
            
            }
            
        <<< UpdateTeamRow("UpdateTeamRow1") { row in
            row.teamName = teamName1
        }.onCellSelection({ (cell, row) in
            
            if let nextRow = self.form.rowByTag("UpdatePlayerPointsRow") {
                // nextRow.hidden = row.value ? true : false
                
                if row.value == true {
                    nextRow.hidden = true
                } else {
                    nextRow.hidden = false
                }
                nextRow.evaluateHidden()
            }

        })
            
        <<< UpdatePlayerPointsRow("UpdatePlayerPointsRow") { row in
            row.name = "Devin Thomas"
            row.pointValue = 50
            row.hidden = true
            row.evaluateHidden()
        }
            
        <<< UpdateTeamRow() { row in
            row.teamName = teamName2
        }
        
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
    
    func configureForm() {
        
    }
    
    func customizeFormAppearance() {
        
    }
    
}
