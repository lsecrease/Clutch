//
//  PlayerForTeamCell.swift
//  CL
//
//  Created by iwritecode on 12/24/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//

import UIKit
import Eureka


open class PlayerForTeamCell: Cell<Player>, CellType {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
//    var name: String = "" {
//        didSet {
//            nameLabel.text = name
//        }
//    }
//    
//    var value: String = "" {
//        didSet {
//            valueLabel.text = "$\(value)"
//        }
//    }
    
    required public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override open func setup() {
        super.setup()
        
        selectionStyle = .none
    }
    
}

public final class PlayerForTeamRow: Row<PlayerForTeamCell>, RowType {
    
    var name: String = "" {
        didSet {
            self.cell.nameLabel.text = name
        }
    }
            
    var pointValue: Float = 0 {
        didSet {
            self.cell.valueLabel.text = "$\(pointValue))"
        }
    }
    

    
    required public init(tag: String?) {
        super.init(tag: tag)
        
        cellProvider = CellProvider<PlayerForTeamCell>(nibName: "PlayerForTeamCell")
    }
    
}
