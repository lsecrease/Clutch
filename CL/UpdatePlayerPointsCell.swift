//
//  UpdatePlayerPointsCell.swift
//  CL
//
//  Created by iwritecode on 12/30/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//

import UIKit
import Eureka

public class UpdatePlayerPointsCell: Cell<Int>, CellType {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pointLabel: UILabel!
    
    let maxPoints = 100
    let minPoints = 1
    
    required public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    override public func setup() {
        super.setup()
    }
    
    @IBAction func stepperPressed(sender: UIStepper) {
        
        pointLabel.text = "\(sender.value) pts"
        
    }
    
}

final class UpdatePlayerPointsRow: Row<Int, UpdatePlayerPointsCell>, RowType {
    
    required init(tag: String?) {
        super.init(tag: tag)
        
        cellProvider = CellProvider<UpdatePlayerPointsCell>(nibName: "UpdatePlayerPointCell")
        
    }
    
    override func customDidSelect() {
        super.customDidSelect()
        
    }
    
    
}
