//
//  CreateGameFormViewController.swift
//  CL
//
//  Created by iwritecode on 12/8/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//

import Eureka
import UIKit

class CreateGameFormViewController: FormViewController {
    
    var createGameTable: UITableView!
    var rowShouldExpand: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureForm()
    
    }
    
    
    
    func configureForm() {
        
        // Customize TableView
        
        self.tableView?.sectionHeaderHeight = 0
        self.tableView!.separatorStyle = .None
        
        self.createGameTable = self.tableView
        
        // Configure Cell appearance
        
        // PickerInlineRow.defaultCellUpdate = { cell, row in cell.height = { 70.0 }; cell.textLabel.font = UIFont(name: "Helvetica Neue", size: 15.0) }
        
        TextRow.defaultCellUpdate = { cell, row in
            cell.textLabel!.font = UIFont(name: "Helvetica Neue", size: 15.0);
            cell.textField.font = UIFont(name: "Helvetica Neue", size: 15.0);
            cell.textField.spellCheckingType = .No
            cell.height = { 70.0 } }
        
        AddPlayerRow.defaultCellUpdate = { cell, row in
            cell.textLabel!.font = UIFont(name: "Helvetica Neue", size: 15.0);
            cell.height = { 60.0 } }
        IntRow.defaultCellUpdate = { cell, row in cell.textLabel!.font = UIFont(name: "Helvetica Neue", size: 15.0); cell.textField.font = UIFont(name: "Helvetica Neue", size: 15.0);cell.height = { 70.0 } }
        DateTimeInlineRow.defaultCellUpdate = { cell, row in cell.textLabel!.font = UIFont(name: "Helvetica Neue", size: 15.0); cell.height = { 60.0 }  }
        
        
        // Add rows
        
        form +++ TextRow() {
                $0.title = "Category"
                $0.placeholder = "Input"
            }
            
            <<< TextRow() {
                $0.title = "Team 1"
                $0.placeholder = "Input"
            }            
            
            <<< AddPlayerRow() {
                $0.title = "Add Player to Team 1"
                $0.cell.addButton.addTarget(self, action: #selector(CreateGameFormViewController.addButtonPressed), forControlEvents: .TouchUpInside)
            }
            
            <<< TextRow() {
                $0.title = "Team 2"
                $0.placeholder = "Input"
            }
            
            <<< AddPlayerRow() {
                $0.title = "Add Player to Team 2"
                
            }

            <<< IntRow() {
                $0.title = "Participant Starting Value"
                $0.placeholder = "Input"
            }
            
            <<< TextRow() {
                $0.title = "Venue Name"
                $0.placeholder = "Input"
            }
        
            <<< DateTimeInlineRow() {
                $0.title = "End Registration"
            }

    }
    
    func addButtonPressed() {
        let addPlayerCellIndexPath = NSIndexPath(forItem: 1, inSection: 0)
        
        rowShouldExpand = !rowShouldExpand
        
        self.createGameTable.beginUpdates()
        self.createGameTable.reloadRowsAtIndexPaths([addPlayerCellIndexPath], withRowAnimation: .Automatic)
        self.createGameTable.endUpdates()
        
    }
    
}

extension CreateGameFormViewController {

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 2, 4:
            print("Add Player Row Selected")
        default:
            break
        }
    }
    
    
}
