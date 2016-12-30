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

public class AddPlayerCell: Cell<Bool>, CellType {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addButton: RotatingButton!
    @IBOutlet weak var topSeparator: UIView!
    
    required public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override public func setup() {
        super.setup()
        
        selectionStyle = .None
        editingAccessoryType = .None
        
        titleLabel.font = defaultFont
        topSeparator.hidden = true
        height = { return 65 }
        
    }
    
    override public func update() {
        super.update()
        
        textLabel?.text = nil
        
    }
    
    public override func didSelect() {
        super.didSelect()

    }
    
}


final class AddPlayerRow: Row<Bool, AddPlayerCell>, RowType {
    
    
    required init(tag: String?) {
        super.init(tag: tag)
        
        cellProvider = CellProvider<AddPlayerCell>(nibName: "AddPlayerCell", bundle: nil)
        self.value = true
    }
    
    override func customDidSelect() {
        super.customDidSelect()
        
        if self.value == true {
            let finalImage = UIImage(named: "cancel")
            self.cell.addButton.turnBack(finalImage)
        } else {
            let finalImage = UIImage(named: "plus")
            self.cell.addButton.turnForward(finalImage)
        }
        
    }
    
    
}