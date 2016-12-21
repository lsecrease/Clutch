//
//  AddPlayerInlineCell.swift
//  CL
//
//  Created by iwritecode on 12/21/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//

import UIKit
import Eureka

public class AddPlayerInlineCell: Cell<Player>, CellType {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addButton: RotatingButton!
    
    required public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override public func setup() {
        super.setup()
        
        selectionStyle = .None
        editingAccessoryType = .None
        
        titleLabel.font = defaultFont
        height = { return 65 }
        
    }
    
    override public func update() {
        super.update()
        
        textLabel?.text = nil
        
    }
    
    
}


final class _AddPlayerInlineRow<Z>: Row<Player, AddPlayerInlineCell>, RowType, InlineRowType {
    
    
    typealias InlineRow = _AddPlayerRow<Player>
    
    required init(tag: String?) {
        super.init(tag: tag)
        
        cellProvider = CellProvider<AddPlayerInlineCell>(nibName: "AddPlayerInlineCell", bundle: nil)
        
        onExpandInlineRow { (cell, row, _) in
            cell.addButton.rotateForward()
            
        }
        
        onCollapseInlineRow { (cell, row, _) in
            cell.addButton.rotateToOrigin()
        }
        
        
    }
    
    func setupInlineRow(inlineRow: InlineRow) {
        
        // cell.titleLabel.text = self.title
    }
    
    override func customDidSelect() {
        super.customDidSelect()
        
        if !isDisabled {
            toggleInlineRow()
        }
    }
    
    
}