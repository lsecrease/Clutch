//
//  CreateGameTableViewController.swift
//  CL
//
//  Created by iwritecode on 12/15/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//


import UIKit

//class CreateGameTableViewController: ExpandableTableViewController {
//    
//    let idCellCategory = "idCellCategory"
//    let idCellTeam1 = "idCellTeam1"
//    let idCellExpandableAddPlayer1 = "idCellExpandableAddPlayer1"
//    let idCellAddPlayer1 = "idCellAddPlayer1"
//    let idCellTeam2 = "idCellTeam2"
//    let idCellExpandableAddPlayer2 = "idCellExpandableAddPlayer2"
//    let idCellAddPlayer2 = "idCellAddPlayer2"
//    let idCellStartingValue = "idCellStartingValue"
//    let idCellCoordinates = "idCellCoordinates"
//    let idCellVenue = "idCellVenue"
//    let idCellRegistration = "idCellRegistration"
//
//    
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        self.expandableTableView.expandableDelegate = self
//        
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        self.expandableTableView.expandableDelegate = self
//        
//        registerCells()
//    }
//    
//    func configureViews() {
//        
//    }
//    
//    func configureNavigationBar() {
//        
//    }
//    
//    func registerCells() {
//        expandableTableView.registerNib(UINib(nibName: "TextCell", bundle: nil), forCellReuseIdentifier: "idCellText")
//        expandableTableView.registerNib(UINib(nibName: "AddPlayerCell", bundle: nil), forCellReuseIdentifier: "idCellAddPlayer")
//        expandableTableView.registerNib(UINib(nibName: "AddPlayerExpandableCell", bundle: nil), forCellReuseIdentifier: "idCellExpandableAddPlayer")
//    }
//    
//    func cancelButtonPressed() {
//        print("Cancel button pressed")
//    }
//    
//    @IBAction func addPlayerButtonPressed(sender: UIButton) {
//        
//    }
//
//}
//
//extension CreateGameTableViewController: ExpandableTableViewDelegate {
//    
//    // Rows...
//    
//    func expandableTableView(expandableTableView: ExpandableTableView, numberOfRowsInSection section: Int) -> Int {
//        return 9
//    }
//    
//    func expandableTableView(expandableTableView: ExpandableTableView, cellForRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> UITableViewCell {
//        
//        var cell = UITableViewCell()
//        
//        switch expandableIndexPath.row {
//        case 0:
//            cell = expandableTableView.dequeueReusableCellWithIdentifier(idCellCategory, forIndexPath: expandableIndexPath) as! TextCell
//            
//        case 1:
//            cell = expandableTableView.dequeueReusableCellWithIdentifier(idCellTeam1, forIndexPath: expandableIndexPath) as! TextCell
//            
//        case 2:
//            cell = expandableTableView.dequeueReusableCellWithIdentifier(idCellExpandableAddPlayer1, forIndexPath: expandableIndexPath) as! AddPlayerExpandableCell
//            
//        case 3:
//            cell = expandableTableView.dequeueReusableCellWithIdentifier(idCellTeam2, forIndexPath: expandableIndexPath) as! TextCell
//            
//        case 4:
//            cell = expandableTableView.dequeueReusableCellWithIdentifier(idCellExpandableAddPlayer2, forIndexPath: expandableIndexPath) as! AddPlayerExpandableCell
//
//        case 5:
//            cell = expandableTableView.dequeueReusableCellWithIdentifier(idCellStartingValue, forIndexPath: expandableIndexPath) as! TextCell
//
//        case 6:
//            cell = expandableTableView.dequeueReusableCellWithIdentifier(idCellCoordinates, forIndexPath: expandableIndexPath) as! MultiInputCell
//            
//        case 7:
//            cell = expandableTableView.dequeueReusableCellWithIdentifier(idCellVenue, forIndexPath: expandableIndexPath) as! TextCell
//
//        default:
//            break
//            
//        }
//        
//        return cell
//        
//    }
//    
//    func expandableTableView(expandableTableView: ExpandableTableView, heightForRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> CGFloat {
//        
//        //        if let cell = expandableTableView.cellForRowAtIndexPath(expandableIndexPath) as? AddPlayerExpandableCell {
//        //            if cell.isExpanded {
//        //                return 0
//        //            } else {
//        //                return 65.0
//        //            }
//        //        }
//        return 65.0
//    }
//    
//    func expandableTableView(expandableTableView: ExpandableTableView, estimatedHeightForRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> CGFloat {
//        
//        //        if let cell = expandableTableView.cellForRowAtIndexPath(expandableIndexPath) as? AddPlayerExpandableCell {
//        //            if cell.isExpanded {
//        //                return 65
//        //            } else {
//        //                return 0
//        //            }
//        //        }
//        return 65.0
//    }
//    
//    func expandableTableView(expandableTableView: ExpandableTableView, didSelectRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) {
//        
//        if let cell = expandableTableView.cellForRowAtIndexPath(expandableIndexPath) as? AddPlayerExpandableCell {
////            cell.descriptionView.hidden = !cell.descriptionView.hidden
//            cell.isExpanded = !cell.isExpanded
//        }
//    }
//    
//    
//    // Subrows
//    
//    func expandableTableView(expandableTableView: ExpandableTableView, numberOfSubRowsInRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> Int {
//        switch expandableIndexPath.row {
//        case 2, 4:
//            return 1
//        default:
//            return 0
//        }
//    }
//    
//    func expandableTableView(expandableTableView: ExpandableTableView, subCellForRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> UITableViewCell {
//        var cell = UITableViewCell()
//        
//        switch expandableIndexPath.row {
//            
//        case 2:
//            cell = expandableTableView.dequeueReusableCellWithIdentifier(idCellAddPlayer1, forIndexPath: expandableIndexPath) as! AddPlayerCell
//        case 4:
//            cell = expandableTableView.dequeueReusableCellWithIdentifier(idCellAddPlayer2, forIndexPath: expandableIndexPath) as! AddPlayerCell
//            
//        default:
//            break
//        }
//        
//        return cell
//        
//    }
//    
//    func expandableTableView(expandableTableView: ExpandableTableView, heightForSubRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> CGFloat {
//        
//        switch expandableIndexPath.row {
//        case 2, 4:
//            return 200.0
//        default:
//            return 0
//        }
//    }
//    
//    func expandableTableView(expandableTableView: ExpandableTableView, estimatedHeightForSubRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) -> CGFloat {
//        
//        switch expandableIndexPath.row {
//        case 2, 4:
//            return 200.0
//        default:
//            return 0
//        }
//        
//    }
//    
//    func expandableTableView(expandableTableView: ExpandableTableView, didSelectSubRowAtExpandableIndexPath expandableIndexPath: ExpandableIndexPath) {
//        
//        switch expandableIndexPath.row {
//        case 2, 4:
//            print("Expandable Cell Clicked")
//        default:
//            break
//        }
//        
//    }
//    
//}
