//
//  AddPlayerCell.swift
//  CL
//
//  Created by iwritecode on 12/21/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//


import UIKit
import Spring
import Eureka

open class AddPlayerCell: Cell<Bool>, CellType {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addButton: RotatingButton!
    @IBOutlet weak var topSeparator: UIView!
    
    required public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func setup() {
        super.setup()
        
        selectionStyle = .none
        editingAccessoryType = .none        
        titleLabel.font = defaultFont //fatal error: found nil
        topSeparator.isHidden = true //fatal error: found nil
        height = { return 65 }
    }
    
    override open func update() {
        super.update()
        
        textLabel?.text = nil
        
    }
    
    open override func didSelect() {
        super.didSelect()

    }
    
}

// BOOL
final class AddPlayerRow: Row<AddPlayerCell>, RowType {
    
    
    required init(tag: String?) {
        super.init(tag: tag)
        
        cellProvider = CellProvider<AddPlayerCell>(nibName: "AddPlayerCell", bundle: nil)
        self.value = true
    }
    
    override func customDidSelect() {
        super.customDidSelect()
        
        if self.value == true {
            let finalImage = UIImage(named: "cancel")
            self.cell.addButton.turnBack(finalImage, padding: 0)
        } else {
            let finalImage = UIImage(named: "plus")
            self.cell.addButton.turnForward(finalImage, padding: 0)
        }
        
    }
    
    
}
