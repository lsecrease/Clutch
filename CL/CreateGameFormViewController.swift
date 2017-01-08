//
//  CreateGameFormViewController.swift
//  CL
//
//  Created by iwritecode on 12/8/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//


import CoreLocation
import Eureka
import Firebase
import UIKit


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
    
    // Form properties
    var participantStartingValue: Int!
    var gameLatitude: Float!
    var gameLongitude: Float!
    var gameVenue: String!
    var gameRegistrationEnd: NSDate!
    var team1IsVisible = false
    var team2IsVisible = false
    
    
    // MARK: Firebase Datbase Reference
    
    var gameRef = FIRDatabase.database().reference()
    var isConnectedToDatabase = false
    
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
    
    // MARK: Firebase functions
    
    func configureDatabase() {

    }
    
    func configureStorage() {
        
    }
    
    func sendGameData(data: [String : String]) {

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
            
            // Category
            
            <<< PickerInlineRow<String>("Category Row") { (row : PickerInlineRow<String>) -> Void in
                row.options = categories
                row.title = "Category"
                row.value = row.options[0]
                row.cell.height = { 65 }
                row.cell.detailTextLabel?.textColor = UIColor.blackColor()
            }.onChange({ (picker) in

                picker.hidden = .Predicate(NSPredicate(format: "$RowName != nil"))
                
                if picker.value != nil {
                    self.game.category = picker.value!
                    print("CATEGORY: \(self.game.category)")
                }

            })
            
            // Team 1
            
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
            
            
            // Team 1
            
            <<< AddPlayerRow() { row in
                    row.tag = "AddPlayerRow1"
                }.onCellSelection({ (cell, row) in
                    
                    // Toggle true/false to display inputrow below
                    row.value = !row.value!

                })
            
            
            // Add Player to Team 1
            
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
            
            
            // Team 2
            
            <<< TextRow() {
                $0.title = "Team 2"
                $0.placeholder = "Input"
                $0.tag = "Team2"
            }.onChange({ (row) in
                
                if row.value != nil {
                    self.game.team2.name = row.value!
                }
                
            })
            
            
            // Add Player to Team 2

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
                
                if let latString = row.cell.latitudeField.text,
                    let lat = Float(latString) {
                    
                    print("LATSTRING: \(latString)")

                    self.game.latitude = lat
                }
                
                if let lonString = row.cell.longitudeField.text,
                    let lon = Float(lonString) {
                    
                    print("LONSTRING: \(lonString)")

                    self.game.latitude = lon
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
            }.onChange({ (dateInlineRow) in
                self.game.endRegistration = dateInlineRow.value!
            })
        }
    
    
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
    
    // Remove input accessory view
    
    override func inputAccessoryViewForRow(row: BaseRow) -> UIView? {
        return nil
    }
    
    func checkTeamVisibility() {
        
        // This function checks if the player rows for teams are visible
        // using boolean values.
        
        
        if game.team2.players.count > 0 {
            if let addPlayerRow2 = self.form.rowByTag("AddPlayerRow2") as? AddPlayerRow {
                if addPlayerRow2.value == true {
                    self.team2IsVisible = true
                } else {
                    self.team2IsVisible = false
                }
            }
        }

    }
    
    func printAllValues() {
        print("CATEGORY: \(self.game.category)")
        print("TEAM 1: \(self.game.team1.name)")
        print("TEAM 1 PLAYERS: \(self.game.team1.players)")
        print("TEAM 2: \(self.game.team2.name)")
        print("TEAM 2 PLAYERS: \(self.game.team2.players)")
        print("PARTICIPANT STARTING VALUE: \(self.game.startingValue)")
        print("LATITUDE: \(self.game.latitude)")
        print("LONGITUDE: \(self.game.longitude)")
        print("VENUE: \(self.game.venue)")
        print("END REGISTRATION: \(self.game.endRegistration)")
        
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
    
    
    // MARK: Row Editing
    
    func allowEditingForPlayerRow(row playerForTeamRow: PlayerForTeamRow) {
        
        var inputRow = AddPlayerInputRow()
        var player = Player()
        
        print("INDEXPATH.ROW: \(playerForTeamRow.indexPath()!.row)")
        
        if playerForTeamRow.indexPath()!.row < self.form.rowByTag("AddPlayerInputRow1")?.indexPath()!.row {
            inputRow = self.form.rowByTag("AddPlayerInputRow1") as! AddPlayerInputRow
            player = game.team1.players[playerForTeamRow.indexPath()!.row - 2]
        } else {
            inputRow = self.form.rowByTag("AddPlayerInputRow2") as! AddPlayerInputRow
            // player = game.team2.players[playerForTeamRow.indexPath()!.row]
        }
        
        inputRow.cell.nameField.text = player.name
        inputRow.cell.numberField.text = "\(player.number)"
        inputRow.cell.pointValueField.text = "\(player.pointValue)"

    }
    
    func deletePlayerRowAtIndexPath(indexPath: NSIndexPath) {
        
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
            // self.performSegueWithIdentifier("showUpdatePointsVC", sender: self)
        }
        
        printAllValues()
        
    }
    
    
    // MARK: UITableView Delegate functions
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        var actions = [UITableViewRowAction]()
        let noActions = [UITableViewRowAction]()
    
        // Delete Action
        let deleteAction = UITableViewRowAction(style: .Destructive, title: "Delete") { (action, indexPath) in
            // Run code to delete player
            print("Delete button clicked")
        
        }
        
        // Edit Action
        let editAction = UITableViewRowAction(style: .Normal, title: "Edit") { (action, indexPath) in
            // Run code to edit player info
            print("Edit button clicked")
            
            if let playerForTeamRow = self.form.allRows[indexPath.row] as? PlayerForTeamRow {
                self.allowEditingForPlayerRow(row: playerForTeamRow)
            }
            
        }
        
        editAction.backgroundColor = UIColor.orangeColor()
        
        // Add to array
        actions.append(deleteAction)
        // actions.append(editAction)
        
        // Set for player rows
        if game.team1.players.count > 0 {
            if let teamRow1 = self.form.rowByTag("Team1") as? TextRow,
                let addPlayerRow1 = self.form.rowByTag("AddPlayerRow1") as? AddPlayerRow {
                if indexPath.row > teamRow1.indexPath()!.row && indexPath.row < addPlayerRow1.indexPath()!.row {
                    return actions
                }

            }
        }

        if game.team2.players.count > 0 {
            if let teamRow2 = self.form.rowByTag("Team2") as? TextRow,
                let addPlayerRow2 = self.form.rowByTag("AddPlayerRow2") as? AddPlayerRow {
                if indexPath.row > teamRow2.indexPath()!.row && indexPath.row < addPlayerRow2.indexPath()!.row {
                    return actions
                }
                
            }
        }
        
        // Return nothing otherwise
        return noActions
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        //Make only player rows editable
        
        if game.team1.players.count > 0 {
            if let teamRow1 = self.form.rowByTag("Team1") as? TextRow,
                let addPlayerRow1 = self.form.rowByTag("AddPlayerRow1") as? AddPlayerRow {
                if indexPath.row > teamRow1.indexPath()!.row && indexPath.row < addPlayerRow1.indexPath()!.row {
                    return true
                }
            }
        }
        
        if game.team2.players.count > 0 {
            if let teamRow2 = self.form.rowByTag("Team2") as? TextRow,
                let addPlayerRow2 = self.form.rowByTag("AddPlayerRow2") as? AddPlayerRow {
                if indexPath.row > teamRow2.indexPath()!.row && indexPath.row < addPlayerRow2.indexPath()!.row {
                    return true
                }
            }
        }
        
        return false

    }
    
    
}



