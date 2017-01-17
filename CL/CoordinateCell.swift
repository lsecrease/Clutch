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
    
    var latitudeAdded = false
    var longitudeAdded = false
    

    @IBOutlet weak var latitudeField: UITextField!
    @IBOutlet weak var longitudeField: UITextField!

    override public func setup() {
        super.setup()
        
        selectionStyle = .None
        height = { 65 }
        
    }
    
    @IBAction func textFieldDidEndEditing(sender: UITextField) {
//        switch sender {
//        case latitudeField:
//            if let latString = self.latitudeField.text {
//                print("LAT STRING:")
//                print(latString)
//                print("LAT STRING AS FLOAT:")
//                print(Float(latString)!)
//                self.row.value?.latitude = Float(latString)!
//            }
//            
//        case longitudeField:
//            if let lonString = self.longitudeField.text {
//                print("LON STRING:")
//                print(lonString)
//                print("LON STRING AS FLOAT:")
//                print(Float(lonString)!)
//                self.row.value?.longitude = Float(lonString)!
//            }
//            
//        default:
//            break
//            
//        }
        
    }
    

    
    
}

public class CoordinateRow: Row<Coordinates, CoordinateCell>, RowType {
    
    required public init(tag: String?) {
        super.init(tag: tag)
        
        cellProvider = CellProvider<CoordinateCell>(nibName: "CoordinateCell")
        
    }
    
}
