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

    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

public class CoordinateRow: Row<Coordinates, CoordinateCell>, RowType {
    
    required public init(tag: String?) {
        super.init(tag: tag)
        
    }
    
}
