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
import SwiftLoader
import UIKit


// MARK: - CreateGameFormViewController

class CreateGameFormViewController: FormViewController {
    
    var createGameButton = UIButton()
    
    // let categories = ["MLB", "MLS", "NCAA Basketball", "NCAA Football", "NBA", "NFL", "NHL"]
    let categorykeys = ["mlb", "mls", "ncaa-basketball", "ncaa-football", "nba", "nfl", "nhl"]
    
    var categories = [String]()
    
    let categoryDict: [String : String] = [
        "MLB" : "mlb",
        "MLS" : "mls",
        "NCAA Basketball" : "ncaa-basketball",
        "NCAA Football" : "ncaa-football",
        "NBA" : "nba",
        "NFL" : "nfl",
        "NHL" : "nhl"
    ]
    
    var game = Game()
    
    // Team 1
    var teamName1: String!
    var playerForTeam1: Player!
    var playersForTeam1 = [Player]()
    var playerKeys1 = [String]()
    
    // Team 2
    var teamName2: String!
    var playerForTeam2: Player!
    var playersForTeam2 = [Player]()
    var playerKeys2 = [String]()
    
    // Form properties
    var participantStartingValue: Int!
    var gameLatitude: Float!
    var gameLongitude: Float!
    var gameVenue: String!
    var gameRegistrationEnd: NSDate!
    var team1IsVisible = false
    var team2IsVisible = false
    
    var missingInputs = [String]()
    
    
    // MARK: Firebase Datbase Reference
    
    var gameRef = FIRDatabaseReference()
    var teamRef1 = FIRDatabaseReference()
    var teamRef2 = FIRDatabaseReference()
    
    var isConnectedToDatabase = false
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView?.backgroundColor = UIColor.whiteColor()
        
        categories = [String](categoryDict.keys)
        
        loadForm()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        createGameButton.setTitle("Create Game", forState: .Normal)
        createGameButton.setTitleColor(createGameButton.tintColor, forState: .Normal)
        
//        teamRef1.child("players").observeEventType(.Value) { (snapshot) in
//            
//        }
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.form.removeAll()
        self.configureForm()

    }
    
    // MARK: Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showUpdatePointsVC" {
            if let updatePointsVC = segue.destinationViewController as? UpdatePointsViewController {
                updatePointsVC.team1 = self.game.team1
                updatePointsVC.team2 = self.game.team2
                updatePointsVC.teamRef1 = self.teamRef1
                updatePointsVC.teamRef2 = self.teamRef2
            }
        }
    }
    
    // MARK: Deinitialization
    
    deinit {
        
    }

    
    // MARK: Eureka Form
    
    func loadForm() {
        customizeFormAppearance()
        configureForm()
    }
    
    func configureForm() {
        
        // Initialize form
        
        form
            
            // ADD & CONFIGURE SECTION
            
            +++ Section { Section in
                Section.header = HeaderFooterView<UIView>(HeaderFooterProvider.Class)
                Section.header!.height = { 0.5 }
                Section.tag = "MainSection"
            }
            
            // ADD ROWS
            
            // Category
            
            <<< PickerInlineRow<String>("Category Row") { (row : PickerInlineRow<String>) -> Void in
                row.options = categories
                row.title = "Category"
                // row.value = row.options[2]
                row.value = "Select"
                row.cell.height = { 65 }
                row.cell.detailTextLabel?.textColor = UIColor.blackColor()
            }.onChange({ (picker) in
                picker.hidden = .Predicate(NSPredicate(format: "$RowName != nil"))
                
                if picker.value != nil && picker.value != "Select" {
                    // self.game.category = picker.value!
                    self.game.category = self.categoryDict[picker.value!]!
                }
            })
            
            
            // Team 1 name
            
            <<< TextRow() { row in
                row.title = "Team 1"
                row.placeholder = "Input"
                row.tag = "Team1"
            }.onChange({ (row) in
                if row.value != nil {
                    self.game.team1.name = row.value!
                }
            })
            
            
            // Add Player to Team 1 (Expanding row)
            
            <<< AddPlayerRow() { row in
                    row.tag = "AddPlayerRow1"
                }.onCellSelection({ (cell, row) in
                    // Toggle true/false to display input row below
                    row.value = !row.value!
                })
            
            
            // Add Player to Team 1 (Input row)
            
            <<< AddPlayerInputRow() { row in
                row.tag = "AddPlayerInputRow1"
                row.hidden = .Function(["AddPlayerRow1"], { form -> Bool in
                        let row: RowOf<Bool>! = form.rowByTag("AddPlayerRow1")
                        return row.value ?? true == true
                    })
                }.cellSetup({ (cell, row) in
                    cell.addPlayerButton.addTarget(self, action: #selector(self.addPlayerToTeam1), forControlEvents: .TouchUpInside)
                }).onChange({ (row) in
                    if row.value != nil {
                        self.playerForTeam1 = row.value!
                        // self.game.team1.players += [row.value!]
                    }
                })
            
            
            // Team 2 name
            
            <<< TextRow() { row in
                row.title = "Team 2"
                row.placeholder = "Input"
                row.tag = "Team2"
            }.onChange({ (row) in
                
                if row.value != nil {
                    self.game.team2.name = row.value!
                }
                
            })
            
            
            // Add Player to Team 2 (expanding row)

            <<< AddPlayerRow() { row in
                row.tag = "AddPlayerRow2"
                
                }.cellSetup({ (cell, row) in
                    cell.titleLabel.text = "Add Player to Team 2"
                    
                }).onCellSelection({ (cell, row) in
                    
                    if row.value != nil {
                        row.value = !row.value!
                    }

                })
            
            
            // Add Player to Team 2 (Input row)
            
            <<< AddPlayerInputRow() { row in
                row.tag = "AddPlayerInputRow2"
                row.hidden = .Function(["AddPlayerRow2"], { form -> Bool in
                        let row: RowOf<Bool>! = form.rowByTag("AddPlayerRow2")
                        return row.value ?? true == true
                    })
                }.cellSetup({ (cell, row) in
                    cell.addPlayerButton.addTarget(self, action: #selector(self.addPlayerToTeam2), forControlEvents: .TouchUpInside)
                }).onChange({ (row) in
                    
                    if row.value != nil {
                        self.playerForTeam2 = row.value!
                        // self.game.team2.players += [row.value!]
                    }
                    
                })
            
            
            // Participant Starting Value
            
            <<< IntRow() { row in
                row.title = "Participant starting value"
                row.placeholder = "Input"
                row.tag = "StartingValueRow"
            }.onChange({ (row) in
                if row.value != nil {
                    self.game.startingValue = row.value!
                }
            })
            
            
            // Latitude and Longitude
            
            <<< CoordinateRow() { row in
                row.tag = "CoordinateRow"
                row.cell.latitudeField.delegate = self
                row.cell.longitudeField.delegate = self
            }.onChange({ (row) in
                if let latString = row.cell.latitudeField.text,
                    let lat = Float(latString) {
                    self.game.latitude = lat
                }
                
                if let lonString = row.cell.longitudeField.text,
                    let lon = Float(lonString) {
                    self.game.latitude = lon
                }
            })
            
            
            // Venue
            
            <<< TextRow() { row in
                row.title = "Venue Name"
                row.placeholder = "Input"
                row.tag = "Venue"
            }.onChange({ (row) in
                if row.value != nil {
                    self.game.venue = row.value!
                }
            })
            
            // End Registration
        
            <<< DateTimeInlineRow() { row in
                row.title = "End Registration"
                row.value = NSDate()
                row.tag = "EndRegistrationDate"
                
                // Format date appearance
                var formatter = NSDateFormatter()
                formatter.dateStyle = .MediumStyle
                formatter.timeStyle = .ShortStyle
                row.dateFormatter = formatter
                
            }.onChange({ (dateInlineRow) in
                self.game.endRegistration = dateInlineRow.value!
            })
        }
    
    
    // MARK: UI Customization

    func customizeFormAppearance() {
        
        // Table Appearance
        
        self.tableView?.sectionHeaderHeight = 0
        self.tableView?.separatorStyle = .None
        self.tableView?.sectionFooterHeight = 90.0
        
        // Cell appearance
        
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
    
    
    // MARK: Activity Indicator
    
    func hideLoadingIndicator() {
        SwiftLoader.hide()
    }
    
    func showLoadingIndicator() {
        var config: SwiftLoader.Config = SwiftLoader.Config()
        config.size = 100
        config.spinnerColor = UIColor.whiteColor()
        config.foregroundColor = UIColor.blackColor()
        config.foregroundAlpha = 0.7
        config.backgroundColor = UIColor.darkGrayColor()
        config.cornerRadius = 5.0
        SwiftLoader.setConfig(config)
        SwiftLoader.show(animated: true)
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
        
        createGame()

    }
    
    
    // MARK: Game Creation
    
    func createGame() {
        
        // Create database references
        
        gameRef = FIRDatabase.database().reference().child("games").child("category").child(game.category).childByAutoId()
        teamRef1 = gameRef.child("team1")
        teamRef2 = gameRef.child("team2")
        
        if let coordinateRow = self.form.rowByTag("CoordinateRow") as? CoordinateRow {
            if let lat = Float(coordinateRow.cell.latitudeField.text!),
                let lon = Float(coordinateRow.cell.longitudeField.text!) {
                self.game.latitude = lat
                self.game.longitude = lon
            }
        }
        
        // If complete, add game to database. Show missing data otherwise.
        
        if formIsComplete() {
            addGameToDatabase()
            self.performSegueWithIdentifier("showUpdatePointsVC", sender: self)
        } else {
            showMissingInputs()
        }

    }
    
    // MARK: Input Checking
    
    func formIsComplete() -> Bool {
        
        if game.category == "" {
            missingInputs += ["Category"]
        } else {
            print("Category is entered: \(game.category)")
        }
        
        if game.team1.name == "" {
            missingInputs += ["Team 1 name"]
        } else {
            print("Team 1 name is entered: \(game.team1.name)")
        }
        
        if game.team1.players.isEmpty {
            missingInputs += ["Players for Team 1"]
        } else {
            print("Team 1 players entered: \(game.team1.players)")
        }
        
        if game.team2.name == "" {
            missingInputs += ["Team 2 name"]
        } else {
            print("Team 2 name is entered: \(game.team2.name)")
        }
        
        if game.team2.players.isEmpty {
            missingInputs += ["Players for Team 2"]
        } else {
            print("Team 2 players entered: \(game.team2.players)")
        }
        
        if game.startingValue as? Int == nil  {
            missingInputs += ["Participant Starting Value"]
        } else {
            print("Starting Value entered: \(game.startingValue)")
        }
        
        if game.latitude as? Float == nil {
            missingInputs += ["Latitude"]
        } else {
            print("Latitude entered: \(game.latitude)")
        }
        
        if self.game.longitude as? Float == nil {
            missingInputs += ["Longitude"]
        } else {
            print("Longitude entered: \(game.longitude)")
        }
        
        if self.game.venue == "" {
            missingInputs += ["Venue"]
        } else {
            print("Venue entered: \(game.venue)")
        }

        return missingInputs.isEmpty
    }
    
    func showMissingInputs() {
        var message = "Please enter: "
        
        if missingInputs.count > 1 {
            for i in 0..<missingInputs.count - 1 {
                message += missingInputs[i] + ", "
            }
            message += "and "
        }
        
        message += missingInputs[missingInputs.count - 1] + "."
        
        self.showAlert("Incomplete Data", message: message)

    }
    
    func addGameToDatabase() {
        
        // Create database references
        
        let participantRef1 = gameRef.child("participants").childByAutoId()
        let participantRef2 = gameRef.child("participants").childByAutoId()
        
        // Set values on Firebase database
        participantRef1.child("admin").setValue(true)
        participantRef2.child("admin").setValue(false)
        
        
        // Team 1
        teamRef1.child("teamname").setValue(game.team1.name)
        
        for player in game.team1.players {
            let playerRef = teamRef1.child("players").childByAutoId()
            playerRef.child("name").setValue(player.name)
            playerRef.child("number").setValue(player.number)
            playerRef.child("point-value").setValue(player.pointValue)
            playerRef.child("score").setValue(0)
        }
        
        // Team 2
        teamRef2.child("teamname").setValue(game.team2.name)
        
        for player in game.team2.players {
            let playerRef = teamRef2.child("players").childByAutoId()
            playerRef.child("name").setValue(player.name)
            playerRef.child("number").setValue(player.number)
            playerRef.child("point-value").setValue(player.pointValue)
            playerRef.child("score").setValue(0)
        }
        
        // Other game properties
        gameRef.child("latitude").setValue(game.latitude)
        gameRef.child("longitude").setValue(game.longitude)
        gameRef.child("venue").setValue(game.venue)
        // gameRef.child("end-registration").setValue("\(game.endRegistration)")
        gameRef.child("end-registration").setValue(stringFromDate(game.endRegistration))
        gameRef.child("starting-value").setValue(game.startingValue)
    }
    
    
    
    // MARK: Date Formatter
    
    func stringFromDate(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.dateStyle = .FullStyle
        dateFormatter.timeStyle = .ShortStyle
        dateFormatter.dateFormat = "yyyy-mm-dd H:mm"
        dateFormatter.defaultDate = NSDate()
        let dateString = dateFormatter.stringFromDate(date)
        return dateString
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
        
        // Return no actions for other rows
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
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 90.0))
        footerView.backgroundColor = UIColor.whiteColor()
        let buttonWidth: CGFloat = 150
        let buttonHeight: CGFloat = 50.0
        let margin: CGFloat = 15.0
        createGameButton = UIButton(frame: CGRect(x: footerView.bounds.width - buttonWidth - margin, y: footerView.bounds.height - buttonHeight - margin, width: 150, height: 35.0))
        createGameButton.layer.borderWidth = 1.0
        createGameButton.layer.borderColor = createGameButton.tintColor.CGColor
        createGameButton.layer.cornerRadius = 5.0
        createGameButton.setTitle("Create Game", forState: .Normal)
        createGameButton.setTitleColor(createGameButton.tintColor, forState: .Normal)
        createGameButton.titleLabel?.font = UIFont(name: "System", size: 12.0)
        createGameButton.titleLabel?.tintColor = createGameButton.tintColor
        createGameButton.titleLabel?.text = "Create Game"
        createGameButton.addTarget(self, action: #selector(self.createGame), forControlEvents: .TouchUpInside)
        
        footerView.addSubview(createGameButton)
        
        return footerView
    }
    
}

// MARK: - UITextField Delegate functions

extension CreateGameFormViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
//        if let coordinateRow = self.form.rowByTag("CoordinateRow") as? CoordinateRow {
//            if textField.text != nil || textField.text != "" {
//                if textField == coordinateRow.cell.latitudeField {
//                    if let lat = coordinateRow.cell.latitudeField.text {
//                        self.game.latitude = (Float(lat))!
//                    }
//                } else if textField == coordinateRow.cell.longitudeField {
//                    if let lon = coordinateRow.cell.longitudeField.text {
//                        self.game.longitude = Float(lon)!
//                    }
//                }
//            }
//        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if let coordinateRow = self.form.rowByTag("CoordinateRow") as? CoordinateRow {
            if textField == coordinateRow.cell.latitudeField ||
                textField == coordinateRow.cell.longitudeField {
                
                let existingTextHasDecimal = textField.text?.rangeOfString(".") != nil
                let existingTextHasMinus = textField.text?.rangeOfString("-") != nil
                
                let replacementTextIsDecimal = string.rangeOfString(".") != nil
                let replacementTextHasMinus = string.rangeOfString("-") != nil
                
                if Float(string) != nil || string == "-" || string == "." || string == "" {
                    
                    if (existingTextHasDecimal && replacementTextIsDecimal) ||
                        (existingTextHasMinus && replacementTextHasMinus) {
                        return false
                    }
                    
                    if string == "-" && range.location != 0 {
                        return false
                    }
                    
                    return true
                } else {
                    return false
                }
                
            }
        }
        
        return true
        
    }
    
}







