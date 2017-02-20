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
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        cellProvider = CellProvider<UpdatePlayerPointsCell>(nibName: "UpdatePlayerPointsCell")
    }
    
    override open func setup() {
        super.setup()
        
        selectionStyle = .none
    }
    
    @IBAction func stepperPressed(_ sender: UIStepper) {
        
        pointLabel.text = "\(Int(sender.value)) pts"
        row.value = Float(sender.value)
        
        print("NEW VALUE: \(sender.value)")
    }
    
}

public final class UpdatePlayerPointsRow: Row<UpdatePlayerPointsCell>, RowType {
    
    var name: String = "" {
        didSet {
            cell.nameLabel.text = name
        }
    }
    
    var pointValue: Float = 0 {
        didSet {
            cell.pointLabel.text = "\(Int(pointValue)) pts"
            cell.stepper.value = Double(pointValue)
        }
        
    }
    
    public required init(tag: String?) {
        super.init(tag: tag)
        
        cellProvider = CellProvider<UpdatePlayerPointsCell>(nibName: "UpdatePlayerPointsCell")
    }
    
    public override func customDidSelect() {
        super.customDidSelect()
        
    }    
    
}
