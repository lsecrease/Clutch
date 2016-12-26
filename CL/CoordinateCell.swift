//
//  CoordinateCell.swift
//  CL
//
//  Created by iwritecode on 12/21/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//

import UIKit
import CoreLocation
import Eureka

public class CoordinateCell: Cell<Coordinates>, CellType {
    
    @IBOutlet weak var latitudeField: UITextField!
    @IBOutlet weak var longitudeField: UITextField!

    override public func setup() {
        super.setup()
        
        selectionStyle = .None
        height = { 65 }
        
    }
    
    
}

public class CoordinateRow: Row<Coordinates, CoordinateCell>, RowType {
    
    required public init(tag: String?) {
        super.init(tag: tag)
        
        cellProvider = CellProvider<CoordinateCell>(nibName: "CoordinateCell")
        
    }
    
}
