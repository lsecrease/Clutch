//
//  UpdatePlayerPointsCell.swift
//  CL
//
//  Created by iwritecode on 12/30/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//

import UIKit
import Eureka

public class UpdatePlayerPointsCell: Cell<Float>, CellType {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pointLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    let maxPoints = 100
    let minPoints = 1
    
    required public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
    }
    
    override public func setup() {
        super.setup()
        
        selectionStyle = .None
    }
    
    @IBAction func stepperPressed(sender: UIStepper) {
        
        pointLabel.text = "\(Int(sender.value)) pts"
        self.row.value = Float(sender.value)
        
        print("NEW VALUE: \(sender.value)")
    }
    
}

final class UpdatePlayerPointsRow: Row<Float, UpdatePlayerPointsCell>, RowType {
    
    var name: String = "" {
        didSet {
            self.cell.nameLabel.text = name
        }
    }
    
    var pointValue: Float = 0 {
        didSet {
            self.cell.pointLabel.text = "\(Int(pointValue)) pts"
            self.cell.stepper.value = Double(pointValue)
        }
        
    }
    
    required init(tag: String?) {
        super.init(tag: tag)
        
        cellProvider = CellProvider<UpdatePlayerPointsCell>(nibName: "UpdatePlayerPointsCell")
    }
    
    override func customDidSelect() {
        super.customDidSelect()
        
    }    
    
}
