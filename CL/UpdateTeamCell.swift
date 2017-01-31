//
//  UpdateTeamCell.swift
//  CL
//
//  Created by iwritecode on 12/30/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//

import UIKit
import Eureka

open class UpdateTeamCell: Cell<Bool>, CellType {
    
    var hideCells = true
    
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var arrowButton: RotatingButton!
    
    
    required public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    open override func setup() {
        super.setup()
        
        selectionStyle = .none
        teamNameLabel.font = defaultFont
        height = { return 80 }
    }
    
    open override func didSelect() {
        super.didSelect()
        
        
        
    }
    
}


// TODO: this needs to be a bool
final class UpdateTeamRow: Row<UpdateTeamCell>, RowType {
    
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
            self.cell.arrowButton.turn(90.0, direction: .clockwise, finalImage: nil)
        } else {
            self.cell.arrowButton.turn(1, direction: .counterClockwise, finalImage: nil)
        }
        // self.value = !self.value!
        
    }
    
}
