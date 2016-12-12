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

    required init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    func addButtonPressed() {
        print("ADD BUTTON PRESSED")
    }
    
}


final class AddPlayerRow: Row<Bool, AddPlayerCell>, RowType {
    required init(tag: String?) {
        super.init(tag: tag)
        
        cellProvider = CellProvider<AddPlayerCell>(nibName: "AddPlayerCell")
    }
}