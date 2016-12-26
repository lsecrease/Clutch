//
//  CreateGameFormViewController.swift
//  CL
//
//  Created by iwritecode on 12/8/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//


import UIKit
import Eureka
import CoreLocation


// MARK: - CreateGameFormViewController

class CreateGameFormViewController: FormViewController {
    
    let categories = ["MLB", "MLS", "NCAA Basketball", "NCAA Football", "NBA", "NFL", "NHL"]
    
    var gameCategory: String!
    var hideRows1 = true
    var hideRows2 = true
    
    // Team 1
    var teamName1: String!
    var playerForTeam1: Player!
    var playersForTeam1 = [Player]()
    
    // Team 2
    var teamName2: String!
    var playersForTeam2 = [Player]()
    var playerForTeam2: Player!
    
    var participantStartingValue: Int!
    var gameLatitude: Float!
    var gameLongitude: Float!
    var gameVenue: String!
    var gameRegistrationEnd: NSDate!
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadForm()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    // MARK: Eureka Form
    
    func loadForm() {
        customizeFormAppearance()
        configureForm()
    }
    
    func configureForm() {
        
        // Initialize form
        
        form
            
            // Add section and remove section header and footer by setting its height to 0.
                +++ Section {
                    $0.header = HeaderFooterView<UIView>(HeaderFooterProvider.Class)
                    $0.header?.height = { 0 }
                }
            
            // Add rows 
            
            // 1
            
            <<< PickerInlineRow<String>("Category Row") { (row : PickerInlineRow<String>) -> Void in
                
                row.options = categories
                row.title = "Category"
                row.value = row.options[0]
                row.cell.height = { 65 }
            }.onChange({ (picker) in
                // picker.hidden = true
                picker.hidden = Condition.Predicate(NSPredicate(format: "$RowName != nil"))
            })
            
            
            // 2
            
            <<< TextRow() {
                $0.title = "Team 1"
                $0.placeholder = "Input"
                $0.tag = "Team1"
            }.cellSetup({ (cell, row) in
                row.disabled = true
            })
            
            // 3

            <<< AddPlayerRow() { row in
            
                }.onCellSelection({ (cell, row) in
                    if let secondCell = self.form.rowByTag("AddPlayerInputRow1") {
                        secondCell.hidden = cell.shouldHideCells ? true : false
                        secondCell.evaluateHidden()
                    }
                })
            
            <<< AddPlayerInputRow() {
                $0.tag = "AddPlayerInputRow1"
                $0.hidden = hideRows1 ? true : false
                $0.evaluateHidden()
                
                }.cellSetup({ (cell, row) in
                    cell.addPlayerButton.addTarget(self, action: #selector(self.addPlayerToTeam1), forControlEvents: .TouchUpInside)
                }).onChange({ (row) in
                    
                    if row.value != nil {
                        self.playerForTeam1 = row.value!
                    }
                    
                    print("PLAYER TO ADD TO TEAM 1: \(self.playerForTeam1)")
                })
            
            // 4

            <<< TextRow() {
                $0.title = "Team 2"
                $0.placeholder = "Input"
                $0.tag = "Team2"
            }
            
            // 5
            
            // Custom Inline row
            <<< AddPlayerRow() { row in
                
                row.title = "Add Player to Team 2"
                
                }.cellSetup({ (cell, row) in
                    cell.titleLabel.text = "Add Player to Team 2"
                    
                }).onCellSelection({ (cell, row) in
                    
                    if let secondCell = self.form.rowByTag("AddPlayerInputRow2") {
                        secondCell.hidden = cell.shouldHideCells ? true : false
                        secondCell.evaluateHidden()
                    }
                })
            
            <<< AddPlayerInputRow() {
                $0.tag = "AddPlayerInputRow2"
                $0.hidden = hideRows2 ? true : false
                $0.evaluateHidden()
                
                }.cellSetup({ (cell, row) in
                    cell.addPlayerButton.addTarget(self, action: #selector(self.addPlayerToTeam2), forControlEvents: .TouchUpInside)
                }).onChange({ (row) in
                    
                    if row.value != nil {
                        self.playerForTeam2 = row.value!
                    }
                    
                    print("PLAYER TO ADD TO TEAM 1: \(self.playerForTeam2)")
                })
            
            // 6
            
            <<< IntRow() {
                $0.title = "Participant starting value"
                $0.placeholder = "Input"
                $0.tag = "StartingValue"
            }
            
            // 7

            <<< CoordinateRow() { row in
                
            }
            
            // 8
            
            <<< TextRow() {
                $0.title = "Venue Name"
                $0.placeholder = "Input"
                $0.tag = "Venue"
            }
            
            // 9
        
            <<< DateTimeInlineRow() {
                $0.title = "End Registration"
                $0.value = NSDate()
                $0.tag = "EndRegistrationDate"
        
        } // End of form
        
        }
        
        func customizeFormAppearance() {
            // Customize table view
            
            self.tableView?.sectionHeaderHeight = 0
            self.tableView?.separatorStyle = .None
            
            // Customize cell appearance
            
            TextRow.defaultCellUpdate = { cell, row in
                cell.textLabel!.font = defaultFont
                cell.textField.font = defaultFont
                cell.textField.spellCheckingType = .No
                cell.height = { 65 }
            }
            
            IntRow.defaultCellUpdate = { cell, row in
                cell.textLabel!.font = defaultFont
                cell.textField.font = defaultFont
                cell.height = { 65 }
            }
            
            DateTimeInlineRow.defaultCellUpdate = { cell, row in
                cell.textLabel!.font = defaultFont
                cell.height = { 65 }
            }
            
            
        }
    
    func addPlayerButtonPressed() {
        form.rowByTag("AddPlayer1")?.deselect()
    }
    
    
    // MARK: IBAction methods
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        // self.dismissViewControllerAnimated(true, completion: nil)
        
        print("CANCEL BUTTON PRESSED")
    }
    
    @IBAction func doneButtonPressed(sender: UIBarButtonItem) {
        print("TEAM 1:\n")
        print(playersForTeam1)
        print("\nTEAM 2:")
        print(playersForTeam2)
    }
    
    func addPlayerToTeam1() {
        if playerForTeam1 != nil {
            self.playersForTeam1 += [playerForTeam1]
            
            print("Added player to team 1")
        }
        print("PLAYERS FOR TEAM 1: \(playersForTeam1)")
    }

    func addPlayerToTeam2() {
        if playerForTeam2 != nil {
            self.playersForTeam2 += [playerForTeam2]

            print("Added player to team 2")
        }
        
    }

    
    func storePlayersForTeam1() {

    }
    
}


