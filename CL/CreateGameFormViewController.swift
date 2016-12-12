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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureForm()
    
    }
    
    
    
    func configureForm() {
        
        // Configure Cell appearance
        
//        TextRow.defaultCellUpdate = { cell, row in cell.textLabel!.font = UIFont(name: "Helvetica Neue", size: 15.0); cell.height = { 70.0 } }
        
        TextRow.defaultCellUpdate = { cell, row in cell.textLabel!.font = UIFont(name: "Helvetica Neue", size: 15.0) }

        IntRow.defaultCellUpdate = { cell, row in cell.textLabel!.font = UIFont(name: "Helvetica Neue", size: 15.0); cell.height = { 70.0 } }
        DateTimeInlineRow.defaultCellUpdate = { cell, row in cell.textLabel!.font = UIFont(name: "Helvetica Neue", size: 15.0); cell.height = { 70.0 }  }
        
        // Remove separators
        
        self.tableView!.separatorStyle = .None
        
        
        // Add rows
        
        form +++ TextRow() {
            $0.title = "Category"
            $0.placeholder = "Input"
            }
            
            <<< TextRow() {
                $0.title = "Team 1"
                $0.placeholder = "Input"
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
    
}
