//
//  AddPlayerCell.swift
//  CL
//
//  Created by iwritecode on 12/12/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//

import UIKit
import Eureka

final class AddPlayerCell: Cell<Bool>, CellType {
    
    var isExpanded: Bool?
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func setup() {
        super.setup()
                
        addButton.tintColor = UIColor.blueColor()
        addButton.addTarget(self, action: #selector(AddPlayerCell.addButtonPressed), forControlEvents: .TouchUpInside)
        selectionStyle = .None
        
    }

    func addButtonPressed() {
        print("ADD BUTTON PRESSED")
    }
    

}


// Custom rows must conform to RowType protocol

final class AddPlayerRow: Row<Bool, AddPlayerCell>, RowType {
    required init(tag: String?) {
        super.init(tag: tag)
        
        cellProvider = CellProvider<AddPlayerCell>(nibName: "AddPlayerCell")
    }
}