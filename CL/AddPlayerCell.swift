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

public class AddPlayerCell: Cell<Player>, CellType {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var valueField: UITextField!
    @IBOutlet weak var addPlayerButton: DesignableButton!
    
    required public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override public func setup() {
        super.setup()
        
        selectionStyle = .None
        
        height = { return 205 }
    }
    
    override public func update() {
        super.update()
        
    }
    
}


public final class _AddPlayerRow<Z>: Row<Player, AddPlayerCell>, Eureka.RowType {
    
    required public init(tag: String?) {
        super.init(tag: tag)
        
        cellProvider = CellProvider<AddPlayerCell>(nibName: "AddPlayerCell", bundle: nil)
    }
    
    public typealias AddPlayerRow = _AddPlayerRow<Player>
    
    
}