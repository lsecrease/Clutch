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
    
    var shouldHideCells = false
    
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
        
        print("CELL TAPPED")

        if shouldHideCells {
            let finalImage = UIImage(named: "cancel")
            addButton.turnForward(finalImage)
        } else {
            let finalImage = UIImage(named: "plus")
            addButton.turnBack(finalImage)
        }
        
        shouldHideCells = !shouldHideCells

    }
    
}


final class AddPlayerRow: Row<Bool, AddPlayerCell>, RowType {
    
    
    required init(tag: String?) {
        super.init(tag: tag)
        
        cellProvider = CellProvider<AddPlayerCell>(nibName: "AddPlayerCell", bundle: nil)
        
    }
    
    override func customDidSelect() {
        super.customDidSelect()
        
    }
    
    
}