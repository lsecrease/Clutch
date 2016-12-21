//
//  CreateGameFormViewController.swift
//  CL
//
//  Created by iwritecode on 12/8/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//


import UIKit
import Eureka

class CreateGameFormViewController: FormViewController {
    
    typealias AddPlayerInlineRow = _AddPlayerInlineRow<Player>
    
    
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
            
            <<< TextRow() {
                $0.title = "Category"
                $0.placeholder = "Input"
            }
            
            
            // 2
            
            <<< TextRow() {
                $0.title = "Team 1"
                $0.placeholder = "Input"
            }
            
            // 3

            <<< AddPlayerInlineRow() {_ in
                
            }
            
            // 4

            <<< TextRow() {
                $0.title = "Team 2"
                $0.placeholder = "Input"
            }
            
            // 5
            
            // Custom Inline row
            <<< AddPlayerInlineRow() { row in
                row.title = "Add Player to Team 2"
            }
        
            // 6
            
            <<< IntRow() {
                $0.title = "Participant starting value"
                $0.placeholder = "Input"
            }
            
            // 7

//            <<< CoordinateRow() {
//                
//            }
        
            // 8
            
            <<< TextRow() {
                $0.title = "Venue Name"
                $0.placeholder = "Input"
            }
            
            // 9
        
            <<< DateTimeInlineRow() {
                $0.title = "End Registration"
                $0.value = NSDate()
        }
        
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
                cell.height = { 65.0 }
            }
            
            IntRow.defaultCellUpdate = { cell, row in
                cell.textLabel!.font = defaultFont
                cell.textField.font = defaultFont
                cell.height = { 65.0 }
            }
            
            DateTimeInlineRow.defaultCellUpdate = { cell, row in
                cell.textLabel!.font = defaultFont
                cell.height = { 65.0 }
            }
            
        }
    
}

