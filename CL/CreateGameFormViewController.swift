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
    
    var game = Game()
    
    // Team 1
    var teamName1: String!
    var playerForTeam1: Player!
    var playersForTeam1 = [Player]()
    
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showUpdatePointsVC" {
            if let updatePointsVC = segue.destinationViewController as? UpdatePointsViewController {

                updatePointsVC.team1 = self.game.team1
                updatePointsVC.team2 = self.game.team2
                
                updatePointsVC.game = self.game
                
            }
        }
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

                picker.hidden = .Predicate(NSPredicate(format: "$RowName != nil"))
                
                if picker.value != nil {
                    self.game.category = picker.value
                }

            })
            
            
            // 1
            
            <<< TextRow() {
                $0.title = "Team 1"
                $0.placeholder = "Input"
                $0.tag = "Team1"
            }.cellSetup({ (cell, row) in

            }).onChange({ (row) in
                if row.value != nil {
                    self.game.team1.name = row.value!
                }
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
                })
            
            // 4

            <<< TextRow() {
                $0.title = "Team 2"
                $0.placeholder = "Input"
                $0.tag = "Team2"
            }.onChange({ (row) in
                
                if row.value != nil {
                    self.game.team2.name = row.value!
                    
                }
                
            })
            
            
            // 5

            // *** SECOND ROW TO ADD PLAYERS ***
            <<< AddPlayerRow() { row in
                row.tag = "AddPlayerRow2"
                
                }.cellSetup({ (cell, row) in
                    cell.titleLabel.text = "Add Player to Team 2"
                    
                }).onCellSelection({ (cell, row) in
                    
                    if row.value != nil {
                        row.value = !row.value!
                    }
                    
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
                $0.tag = "StartingValueRow"
            }.onChange({ (row) in
                if row.value != nil {
                    self.game.startingValue = row.value!
                }
            })
            
            // 8

            <<< CoordinateRow() {
                $0.tag = "CoordinateRow"
            }.onChange({ (row) in
                if row.value != nil {
                    // Get coordinates
                }
            })
            
            // 9
            
            <<< TextRow() {
                $0.title = "Venue Name"
                $0.placeholder = "Input"
                $0.tag = "Venue"
            }.onChange({ (row) in
                if row.value != nil {
                    self.game.venue = row.value!
                }
            })
            
            // 10
        
            <<< DateTimeInlineRow() {
                $0.title = "End Registration"
                $0.value = NSDate()
                $0.tag = "EndRegistrationDate"
        
            } // END OF FORM
        
        
        } // END OF 'VIEWDIDLOAD'
    
    
        // MARK: Form Appearance Customization
    
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
        
        if game.team1.players.isEmpty {
            let title = "Error"
            let message = "Team #1 Has no player(s). Please add players to the game."
            self.showAlert(title, message: message)
        } else if game.team2.players.isEmpty {
            let title = "Error"
            let message = "Team #2 Has no player(s). Please add players to the game."
            self.showAlert(title, message: message)
        } else {
            self.performSegueWithIdentifier("showUpdatePointsVC", sender: self)
        }

    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alert.addAction(okAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func addPlayerToTeam1() {
        
        if playerForTeam1 != nil {
            
            self.game.team1.players += [playerForTeam1]
            
            print(self.game.team1.players)
            
            
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
        
        playerForTeam1 = nil
        
    }
    
    func addPlayerToTeam2() {
        
        if playerForTeam2 != nil {
            self.game.team2.players += [playerForTeam2]
            
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
        
        playerForTeam2 = nil

    }

    
    func storePlayersForTeam1() {

    }
    
}


