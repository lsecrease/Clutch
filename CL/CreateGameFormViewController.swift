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
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}



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
    var gameRegistrationEnd: Date!
    var team1IsVisible = false
    var team2IsVisible = false
    
    var missingInputs = [String]()
    
    
    // MARK: Firebase Datbase Reference
    
    var ref : FIRDatabaseReference?
    
//    var gameRef : FIRDatabaseReference?
//    var teamRef1 : FIRDatabaseReference?
//    var teamRef2 : FIRDatabaseReference?
    
    var gameBufferTime = 15.0 // 15 min (buffer between game start time and registration closing time

    var gameDict = [String: AnyObject]()

    
    var isConnectedToDatabase = false //Z - don't think we need (look into where this is used)
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView?.backgroundColor = UIColor.white
        
        categories = [String](categoryDict.keys)
        
        loadForm()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        createGameButton.setTitle("Create Game", for: UIControlState())
        createGameButton.setTitleColor(createGameButton.tintColor, for: UIControlState())
        
//        teamRef1.child("players").observeEventType(.Value) { (snapshot) in
//            
//        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.form.removeAll()
        self.configureForm()

    }
    
    // MARK: Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "showUpdatePointsVC" {
//            if let updatePointsVC = segue.destination as? UpdatePointsViewController {
//                updatePointsVC.team1 = self.game.team1
//                updatePointsVC.team2 = self.game.team2
//            }
//        }
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
                Section.header = HeaderFooterView<UIView>(HeaderFooterProvider.class)
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
                row.cell.detailTextLabel?.textColor = UIColor.black
            }.onChange({ (picker) in
                picker.hidden = .predicate(NSPredicate(format: "$RowName != nil"))
                
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
                row.hidden = .function(["AddPlayerRow1"], { form -> Bool in
                    let row: RowOf<Bool>! = form.rowBy(tag: "AddPlayerRow1")
                        return row.value ?? true == true
                    })
                }.cellSetup({ (cell, row) in
                    cell.addPlayerButton.addTarget(self, action: #selector(self.addPlayerToTeam1), for: .touchUpInside)
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
                row.hidden = .function(["AddPlayerRow2"], { form -> Bool in
                    let row: RowOf<Bool>! = form.rowBy(tag: "AddPlayerRow2")
                        return row.value ?? true == true
                    })
                }.cellSetup({ (cell, row) in
                    cell.addPlayerButton.addTarget(self, action: #selector(self.addPlayerToTeam2), for: .touchUpInside)
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
                row.title = "Game Start"
                row.value = Date()
                row.tag = "GameStartDate"
                
                // Format date appearance
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .short
                row.dateFormatter = formatter
                
                }.onChange({ (dateInlineRow) in
                    if let safeDate = dateInlineRow.value{
                        self.game.gameStartTime = safeDate
                        let closeRegistration = safeDate as Date
                        self.game.endRegistration = closeRegistration.addingTimeInterval(self.gameBufferTime * 60.0)
                    }
                })
    }
    
    
    // MARK: UI Customization

    func customizeFormAppearance() {
        
        // Table Appearance
        
        self.tableView?.sectionHeaderHeight = 0
        self.tableView?.separatorStyle = .none
        self.tableView?.sectionFooterHeight = 90.0
        
        // Cell appearance
        
        TextRow.defaultCellUpdate = { cell, row in
            cell.textLabel!.font = defaultFont
            cell.textField.font = defaultFont
            cell.textField.spellCheckingType = .no
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
    override func inputAccessoryView(for row: BaseRow) -> UIView? {
        return nil
    }
    
    
    // MARK: Activity Indicator
    
    func hideLoadingIndicator() {
        SwiftLoader.hide()
    }
    
    func showLoadingIndicator() {
        var config: SwiftLoader.Config = SwiftLoader.Config()
        config.size = 100
        config.spinnerColor = UIColor.white
        config.foregroundColor = UIColor.black
        config.foregroundAlpha = 0.7
        config.backgroundColor = UIColor.darkGray
        config.cornerRadius = 5.0
        SwiftLoader.setConfig(config)
        SwiftLoader.show(animated: true)
    }
    
    func showAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func addPlayerToTeam1() {
        
        if playerForTeam1 != nil {
            
            self.game.team1.players += [playerForTeam1]
            
            if var mainSection = self.form.sectionBy(tag: "MainSection"){
                var index: Int!
                
                if let addPlayerRow1 = self.form.rowBy(tag: "AddPlayerRow1") as? AddPlayerRow {
                    index = addPlayerRow1.indexPath!.row
                }
                
                mainSection.insert(PlayerForTeamRow() { row in
                    
                    if let safePointValue = playerForTeam1.pointValue{
                        row.cell.valueLabel.text = "\(safePointValue)"
                    }
                    row.cell.nameLabel.text = playerForTeam1.name
                    row.hidden = .function(["AddPlayerRow1"], { form -> Bool in
                        let row: RowOf<Bool>! = form.rowBy(tag: "AddPlayerRow1")
                        return row.value ?? true == true
                    })
                    }, at: index)
                
                mainSection.reload()
            }
        
        } else {
            print("PLAYER TO BE ADDED TO TEAM 1 IS NIL")
        }
        
        
        playerForTeam1 = nil
        
    }
    
    func addPlayerToTeam2() {
        
        if playerForTeam2 != nil {
            self.game.team2.players += [playerForTeam2]
            
            if var mainSection = self.form.sectionBy(tag: "MainSection") {
                var index: Int!
                
                if let addPlayerRow2 = self.form.rowBy(tag: "AddPlayerRow2") as? AddPlayerRow {
                    index = addPlayerRow2.indexPath!.row
                }
                
                mainSection.insert(PlayerForTeamRow() { row in
                    if let safePointValue = playerForTeam2.pointValue{
                        row.cell.valueLabel.text = "\(safePointValue)"
                    }
                    row.cell.nameLabel.text = playerForTeam2.name
                    row.hidden = .function(["AddPlayerRow2"], { form -> Bool in
                        let row: RowOf<Bool>! = form.rowBy(tag: "AddPlayerRow2")
                        return row.value ?? true == true
                    })
                    }, at: index)
                
            }

        } else {
            print("PLAYER TO BE ADDED TO TEAM 2 IS NIL")
        }
        
        playerForTeam2 = nil

    }
    
    
    // MARK: Row Editing
    
    func allowEditingForPlayerRow(row playerForTeamRow: PlayerForTeamRow) {
        
        var inputRow = AddPlayerInputRow()
        var player = Player()
        
        if playerForTeamRow.indexPath!.row < self.form.rowBy(tag: "AddPlayerInputRow1")?.indexPath!.row {
            inputRow = self.form.rowBy(tag: "AddPlayerInputRow1") as! AddPlayerInputRow
            player = game.team1.players[playerForTeamRow.indexPath!.row - 2]
        } else {
            inputRow = self.form.rowBy(tag: "AddPlayerInputRow2") as! AddPlayerInputRow
            // player = game.team2.players[playerForTeamRow.indexPath()!.row]
        }
        
        inputRow.cell.nameField.text = player.name
        inputRow.cell.numberField.text = "\(player.number)"
        inputRow.cell.pointValueField.text = "\(player.pointValue)"

    }
    
    
    // MARK: IBAction methods
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        createGame()
    }
    
    
    // MARK: Game Creation
    func createGame() {
        
        if let coordinateRow = self.form.rowBy(tag: "CoordinateRow") as? CoordinateRow {
            if let lat = Float(coordinateRow.cell.latitudeField.text!),
                let lon = Float(coordinateRow.cell.longitudeField.text!) {
                self.game.latitude = lat
                self.game.longitude = lon
            }
        }
        
        
//         If complete, add game to database. Show missing data otherwise.
        if formIsComplete() {
            addGameToDatabase()
            let _ = self.navigationController?.popViewController(animated: true)
        } else {
            showMissingInputs()
        }

    }
    
    // MARK: Input Checking
    
    func formIsComplete() -> Bool {
        missingInputs = []
//        self.view.endEditing(true)
//        return true
        
        if game.category == "" || game.category == "Select" {
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
        
        if game.startingValue as Int? == nil  {
            missingInputs += ["Participant Starting Value"]
        } else {
            print("Starting Value entered: \(game.startingValue)")
        }
        
        if game.latitude as Float? == nil {
            missingInputs += ["Latitude"]
        } else {
            print("Latitude entered: \(game.latitude)")
        }
        
        if self.game.longitude as Float? == nil {
            missingInputs += ["Longitude"]
        } else {
            print("Longitude entered: \(game.longitude)")
        }
        
        if self.game.venue == "" {
            missingInputs += ["Venue"]
        } else {
            print("Venue entered: \(game.venue)")
        }

        if self.game.gameStartTime == nil{
            missingInputs += ["Start time"]
        }else{
            print ("Start time entered: \(game.gameStartTime)")
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
            message += missingInputs[missingInputs.count - 1] + "."
        }
//        else if missingInputs.count == 1 {
//            message += missingInputs[0] + "."
//        }
        
        
        self.showAlert("Incomplete Data", message: message)

    }
    
    func addGameToDatabase() {
        
        
        //set values
        self.gameDict["category"] = self.game.category as AnyObject?
        self.gameDict["startingValue"] = self.game.startingValue as AnyObject?
        self.gameDict["venue"] = self.game.venue as AnyObject?
        
        if let safeDate = self.game.gameStartTime{
            self.gameDict["startTime"] = String(describing: safeDate) as AnyObject?
        }
        if let safeDate = self.game.endRegistration{
            self.gameDict["endRegistrationTime"] = String(describing: safeDate) as AnyObject?
        }
        
        
        self.ref = FIRDatabase.database().reference()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        //Create game in Firebase
        
        guard let safeGameStartTime = self.game.gameStartTime else {
            print("Game start time is nil - this should never happen because of formIsComplete()")
            return }
        
        let gameDate = dateFormatter.string(from: safeGameStartTime)
        if gameDate != ""{
            if self.game.gameID == ""{
                self.game.gameID = (self.ref?.child("/games/\(gameDate)/").childByAutoId().key)!
                
                var childUpdates : [String: AnyObject] = [:]
                
                for detail in self.gameDict{
                    childUpdates["/games/\(gameDate)/\(self.game.gameID)/\(detail.key)"] = self.gameDict[detail.key] as AnyObject?
                }
                
                childUpdates["/games/\(gameDate)/\(self.game.gameID)/location/lat"] = self.game.latitude as AnyObject?
                childUpdates["/games/\(gameDate)/\(self.game.gameID)/location/lon"] = self.game.longitude as AnyObject?
                
                childUpdates["/games/\(gameDate)/\(self.game.gameID)/team1/name"] = self.game.team1.name as AnyObject?
                
                for player in game.team1.players{
                    let playerID = (self.ref?.child("/games/\(gameDate)/\(self.game.gameID)/team1/players").childByAutoId().key)!
                    if let safeIndex = self.game.team1.players.index(of: player){
                        self.game.team1.players[safeIndex].playerID = playerID
                    }
                    
                    childUpdates["/games/\(gameDate)/\(self.game.gameID)/team1/players/\(playerID)/name"] = player.name as AnyObject?
                    childUpdates["/games/\(gameDate)/\(self.game.gameID)/team1/players/\(playerID)/number"] = player.number as AnyObject?
                    childUpdates["/games/\(gameDate)/\(self.game.gameID)/team1/players/\(playerID)/pointValue"] = player.pointValue as AnyObject?
                }
                
                childUpdates["/games/\(gameDate)/\(self.game.gameID)/team2/name"] = self.game.team2.name as AnyObject?
                for player in game.team2.players{
                    let playerID = (self.ref?.child("/games/\(gameDate)/\(self.game.gameID)/team1/players").childByAutoId().key)!
                    if let safeIndex = self.game.team2.players.index(of: player){
                        self.game.team2.players[safeIndex].playerID = playerID
                    }
                    
                    childUpdates["/games/\(gameDate)/\(self.game.gameID)/team2/players/\(playerID)/name"] = player.name as AnyObject?
                    childUpdates["/games/\(gameDate)/\(self.game.gameID)/team2/players/\(playerID)/number"] = player.number as AnyObject?
                    childUpdates["/games/\(gameDate)/\(self.game.gameID)/team2/players/\(playerID)/pointValue"] = player.pointValue as AnyObject?
                }
                self.ref?.updateChildValues(childUpdates)
            }
        }
    }
    
    // MARK: UITableView Delegate functions
    func tableView(_ tableView: UITableView, editActionsForRowAtIndexPath indexPath: IndexPath) -> [UITableViewRowAction]? {
        var actions = [UITableViewRowAction]()
        let noActions = [UITableViewRowAction]()
    
        // Delete Action
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in

            // Delete player from team array
            // Odd code explaination: table is in 1 section, variable rows if team is expanded
            guard let teamRow1 = self.form.rowBy(tag: "Team1") as? TextRow else {return}
            guard let teamRow2 = self.form.rowBy(tag: "Team2") as? TextRow else {return}
            if indexPath.row < teamRow2.indexPath!.row {
                let i = indexPath.row  - (teamRow1.indexPath?.row)! - 1
                self.game.team1.players.remove(at: i)
            } else {
                let i = indexPath.row  - (teamRow2.indexPath?.row)! - 1
                self.game.team2.players.remove(at: i)
            }
            
            
            // Delete row from table
            if var mainSection = self.form.sectionBy(tag: "MainSection") {
                mainSection.remove(at: indexPath.row)
            }
            
        }
        
        // Edit Action
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            // Run code to edit player info
            print("Edit button clicked")
            
            if let playerForTeamRow = self.form.allRows[indexPath.row] as? PlayerForTeamRow {
                self.allowEditingForPlayerRow(row: playerForTeamRow)
            }
            
        }
        
        editAction.backgroundColor = UIColor.orange
        
        // Add to array
        actions.append(deleteAction)
        // actions.append(editAction)
        
        // Set for player rows
        if game.team1.players.count > 0 {
            if let teamRow1 = self.form.rowBy(tag: "Team1") as? TextRow,
                let addPlayerRow1 = self.form.rowBy(tag: "AddPlayerRow1") as? AddPlayerRow {
                if indexPath.row > teamRow1.indexPath!.row && indexPath.row < addPlayerRow1.indexPath!.row {
                    return actions
                }
            }
        }

        if game.team2.players.count > 0 {
            if let teamRow2 = self.form.rowBy(tag: "Team2") as? TextRow,
                let addPlayerRow2 = self.form.rowBy(tag: "AddPlayerRow2") as? AddPlayerRow {
                if indexPath.row > teamRow2.indexPath!.row && indexPath.row < addPlayerRow2.indexPath!.row {
                    return actions
                }
            }
        }
        
        // Return no actions for other rows
        return noActions
    }
    
    func tableView(_ tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: IndexPath) {
        
        if editingStyle == .delete {
            var i = Int()
            
            if let teamRow2 = self.form.rowBy(tag: "Team2") as? TextRow {
                if indexPath.row < teamRow2.indexPath!.row {
                    i = indexPath.row - 2
                    self.game.team1.players.remove(at: i)
                } else {
                    i = indexPath.row - (self.game.team1.players.count + 2)
                    print("TEAM 2 PLAYERS B4 DELETE: \(self.game.team2.players)")
                    self.game.team2.players.remove(at: i)
                    print("TEAM 2 PLAYERS AFTER DELETE: \(self.game.team2.players)")
                }
            }
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
            print("TEAM 2 PLAYERS AFTER DELETE: \(self.game.team2.players)")
        }
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAtIndexPath indexPath: IndexPath) -> Bool {
        
        //Make only player rows editable
        
        if game.team1.players.count > 0 {
            if let teamRow1 = self.form.rowBy(tag: "Team1") as? TextRow,
                let addPlayerRow1 = self.form.rowBy(tag: "AddPlayerRow1") as? AddPlayerRow {
                if indexPath.row > teamRow1.indexPath!.row && indexPath.row < addPlayerRow1.indexPath!.row {
                    return true
                }
            }
        }
        
        if game.team2.players.count > 0 {
            if let teamRow2 = self.form.rowBy(tag: "Team2") as? TextRow,
                let addPlayerRow2 = self.form.rowBy(tag: "AddPlayerRow2") as? AddPlayerRow {
                
                if indexPath.row > teamRow2.indexPath!.row && indexPath.row < addPlayerRow2.indexPath!.row {
                    return true
                }
            }
        }
        
        return false

    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 90.0))
        footerView.backgroundColor = UIColor.white
        let buttonWidth: CGFloat = 150
        let buttonHeight: CGFloat = 50.0
        let margin: CGFloat = 15.0
        createGameButton = UIButton(frame: CGRect(x: footerView.bounds.width - buttonWidth - margin, y: footerView.bounds.height - buttonHeight - margin, width: 150, height: 35.0))
        createGameButton.layer.borderWidth = 1.0
        createGameButton.layer.borderColor = createGameButton.tintColor.cgColor
        createGameButton.layer.cornerRadius = 5.0
        createGameButton.setTitle("Create Game", for: UIControlState())
        createGameButton.setTitleColor(createGameButton.tintColor, for: UIControlState())
        createGameButton.titleLabel?.font = UIFont(name: "System", size: 12.0)
        createGameButton.titleLabel?.tintColor = createGameButton.tintColor
        createGameButton.titleLabel?.text = "Create Game"
        createGameButton.addTarget(self, action: #selector(self.createGame), for: .touchUpInside)
        
        footerView.addSubview(createGameButton)
        
        return footerView
    }
    
}

// MARK: - UITextField Delegate functions
extension CreateGameFormViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let coordinateRow = self.form.rowBy(tag: "CoordinateRow") as? CoordinateRow {
            if textField == coordinateRow.cell.latitudeField ||
                textField == coordinateRow.cell.longitudeField {
                
                let existingTextHasDecimal = textField.text?.range(of: ".") != nil
                let existingTextHasMinus = textField.text?.range(of: "-") != nil
                
                let replacementTextIsDecimal = string.range(of: ".") != nil
                let replacementTextHasMinus = string.range(of: "-") != nil
                
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







