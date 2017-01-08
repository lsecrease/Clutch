//
//  Coordinates.swift
//  CL
//
//  Created by iwritecode on 12/21/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//

import Foundation

public struct Coordinates: Equatable {
    
    var latitude = Float()
    var longitude = Float()
    
    init(latitude: Float, longitude: Float) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

public func ==(lhs: Coordinates, rhs: Coordinates) -> Bool {
    return lhs.latitude == rhs.latitude
}