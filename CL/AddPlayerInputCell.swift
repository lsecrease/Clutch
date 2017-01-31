
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
    @IBOutlet weak var pointValueField: UITextField!
    @IBOutlet weak var addPlayerButton: DesignableButton!
    @IBOutlet weak var topSeparator: UIView!
    
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
        
        height = { return 205 }
    }
    
    override open func update() {
        super.update()
        
    }
    
    @IBAction func addPlayerButtonPressed(_ sender: DesignableButton) {
        
        if let name = nameField.text,
            let number = Int(numberField.text!),
            let pointValue = Float(pointValueField.text!) {
            
            self.row.value = Player(name: name, number: number, pointValue: pointValue, score: 0.0)
            
            nameField.text = ""
            numberField.text = ""
            pointValueField.text = ""
            print(self.row.value!)
        }
        
    }
    
}

// Player
public final class AddPlayerInputRow: Row<AddPlayerInputCell>, RowType {
    
    required public init(tag: String?) {
        super.init(tag: tag)
        //Swift 3: cellProvider --> CellProvider
        cellProvider = CellProvider<AddPlayerInputCell>(nibName: "AddPlayerInputCell", bundle: nil)
    }
    
}
