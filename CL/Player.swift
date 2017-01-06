//
//  Player.swift
//  CL
//
//  Created by iwritecode on 11/27/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//

import Foundation

public struct Player: Equatable {
    
    var name = String()
    var number = Int()
    var pointValue = Float()
    var score = Float()
    
    init() {}
    
    init(name: String, number: Int, pointValue: Float, score: Float) {
        self.name = name
        self.number = number
        self.pointValue = pointValue
        self.score = score
    }
    
}

public func ==(lhs: Player, rhs: Player) -> Bool {
    return lhs.name == rhs.name && lhs.number == rhs.number && lhs.pointValue == rhs.pointValue
}
    
