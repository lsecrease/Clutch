//
//  UpdateTeamCell.swift
//  CL
//
//  Created by iwritecode on 12/30/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//

import UIKit
import Eureka

public class UpdateTeamCell: Cell<Bool>, CellType {
    
    var hideCells = true
    
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var arrowButton: RotatingButton!
    
    
    required public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    public override func setup() {
        super.setup()
        
        selectionStyle = .None
        teamNameLabel.font = defaultFont
        height = { return 80 }
    }
    
    public override func didSelect() {
        super.didSelect()
        
        
        
    }
    
}



final class UpdateTeamRow: Row<Bool, UpdateTeamCell>, RowType {
    
    var teamName: String = "" {
        didSet {
            cell.teamNameLabel.text = teamName
        }
    }

    
    required init(tag: String?) {
        super.init(tag: tag)
        
        cellProvider = CellProvider<UpdateTeamCell>(nibName: "UpdateTeamCell")
        self.value = true
        
    }
    
    override func customDidSelect() {
        super.customDidSelect()
        
        if self.value == true {
            self.cell.arrowButton.turn(90.0, direction: .Clockwise, finalImage: nil)
        } else {
            self.cell.arrowButton.turn(1, direction: .CounterClockwise, finalImage: nil)
        }
        self.value = !self.value!
        
    }
    
}
