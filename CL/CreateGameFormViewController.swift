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
    var hideRows2 = true
    
    var firstInputRow = AddPlayerInputRow()
    
    // Team 1
    var teamName1: String!
    var playerForTeam1: Player!
    var playersForTeam1 = [Player]()
    var firstTeamHidden = true
    
    // Team 2
    var teamName2: String!
    var playerForTeam2: Player!
    var playersForTeam2 = [Player]()
    
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
            
            // Add section and remove section header and footer by setting its height to 0.5
            +++ Section {
                $0.header = HeaderFooterView<UIView>(HeaderFooterProvider.Class)
                $0.header!.height = { 0.5 }
                $0.tag = "MainSection"
            }
            
            // Add rows 
            
            // 0
            
            <<< PickerInlineRow<String>("Category Row") { (row : PickerInlineRow<String>) -> Void in
                row.options = categories
                row.title = "Category"
                row.value = row.options[0]
                row.cell.height = { 65 }
                row.cell.detailTextLabel?.textColor = UIColor.blackColor()
            }.onChange({ (picker) in
                picker.hidden = Condition.Predicate(NSPredicate(format: "$RowName != nil"))
            })
            
            
            // 1
            
            <<< TextRow() {
                $0.title = "Team 1"
                $0.placeholder = "Input"
                $0.tag = "Team1"
            }.cellSetup({ (cell, row) in
                row.disabled = true
            })
            
            
            // 2

            <<< AddPlayerRow() { row in
                    row.tag = "AddPlayerRow1"
                }.onCellSelection({ (cell, row) in
                    row.value = !row.value!
                })
            
            // 3
            
            <<< AddPlayerInputRow() {
                
                $0.tag = "AddPlayerInputRow1"
                $0.hidden = .Function(["AddPlayerRow1"], { form -> Bool in
                        let row: RowOf<Bool>! = form.rowByTag("AddPlayerRow1")
                        return row.value ?? true == true
                    })
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

            // *** SECOND ROW TO ADD PLAYERS ***
            <<< AddPlayerRow() { row in
                row.tag = "AddPlayerRow2"
                
                }.cellSetup({ (cell, row) in
                    cell.titleLabel.text = "Add Player to Team 2"
                    
                }).onCellSelection({ (cell, row) in
                    row.value = !row.value!
                })
            
            // 6
            
            <<< AddPlayerInputRow() {
                $0.tag = "AddPlayerInputRow2"
                $0.hidden = .Function(["AddPlayerRow2"], { form -> Bool in
                        let row: RowOf<Bool>! = form.rowByTag("AddPlayerRow2")
                        return row.value ?? true == true
                    })
                }.cellSetup({ (cell, row) in
                    cell.addPlayerButton.addTarget(self, action: #selector(self.addPlayerToTeam2), forControlEvents: .TouchUpInside)
                }).onChange({ (row) in
                    
                    if row.value != nil {
                        self.playerForTeam2 = row.value!
                    }
                })
            
            // 7
            
            <<< IntRow() {
                $0.title = "Participant starting value"
                $0.placeholder = "Input"
                $0.tag = "StartingValue"
            }
            
            // 8

            <<< CoordinateRow() { row in
                
            }
            
            // 9
            
            <<< TextRow() {
                $0.title = "Venue Name"
                $0.placeholder = "Input"
                $0.tag = "Venue"
            }
            
            // 10
        
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
        
        self.performSegueWithIdentifier("showUpdatePointsVC", sender: self)
    }
    
    func addPlayerToTeam1() {
        if playerForTeam1 != nil {
            self.playersForTeam1 += [playerForTeam1]
            
            
            if var mainSection = self.form.sectionByTag("MainSection") {
                var index: Int!
                
                if let addPlayerRow1 = self.form.rowByTag("AddPlayerRow1") as? AddPlayerRow {
                    index = addPlayerRow1.indexPath()!.row
                }
                
                mainSection.insert(PlayerForTeamRow() { row in
                    row.cell.valueLabel.text = "\(playerForTeam1.pointValue)"
                    row.cell.nameLabel.text = playerForTeam1.name
                    row.hidden = .Function(["AddPlayerRow1"], { form -> Bool in
                        let row: RowOf<Bool>! = form.rowByTag("AddPlayerRow1")
                        return row.value ?? true == true
                    })
                    }, atIndex: index)
                
                mainSection.reload()
            }
        }
        
    }
    
    func addPlayerToTeam2() {

        self.playersForTeam2 += [playerForTeam2]
            
            if var mainSection = self.form.sectionByTag("MainSection") {
                
                var index: Int!
                
                if let addPlayerRow2 = self.form.rowByTag("AddPlayerRow2") as? AddPlayerRow {
                    index = addPlayerRow2.indexPath()!.row
                }
                
                mainSection.insert(PlayerForTeamRow() { row in
                    row.cell.valueLabel.text = "\(playerForTeam2.pointValue)"
                    row.cell.nameLabel.text = playerForTeam2.name
                    row.hidden = .Function(["AddPlayerRow2"], { form -> Bool in
                        let row: RowOf<Bool>! = form.rowByTag("AddPlayerRow2")
                        return row.value ?? true == true
                    })
                    }, atIndex: index)
                
            }

    }

    
    func storePlayersForTeam1() {

    }
    
}


