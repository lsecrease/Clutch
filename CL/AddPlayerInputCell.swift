//
//  AddPlayerInputCell.swift
//  CL
//
//  Created by iwritecode on 12/23/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//

import UIKit
import Eureka
import Spring

public class AddPlayerInputCell: Cell<Player>, CellType {
        
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var valueField: UITextField!
    @IBOutlet weak var addPlayerButton: DesignableButton!
    @IBOutlet weak var topSeparator: UIView!
    
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
    
    @IBAction func addPlayerButtonPressed(sender: DesignableButton) {
        
        if let name = nameField.text,
            let number = numberField.text,
            let pointValue = Float(valueField.text!) {
            
            self.row.value = Player(name: name, number: number, pointValue: pointValue, score: 50.0)
            
            nameField.text = ""
            numberField.text = ""
            valueField.text = ""
            print(self.row.value!)
        }
        
    }
    
}


public final class AddPlayerInputRow: Row<Player, AddPlayerInputCell>, RowType {
    
    required public init(tag: String?) {
        super.init(tag: tag)
        
        cellProvider = CellProvider<AddPlayerInputCell>(nibName: "AddPlayerInputCell", bundle: nil)
    }
    
}