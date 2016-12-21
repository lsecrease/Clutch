//
//  Player.swift
//  CL
//
//  Created by iwritecode on 11/27/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//

import Foundation

public struct Player: Equatable {
    
    var number: String
    var name: String
    var teamName: String
    var pointValue: Int
    var cost: Int
    
    init(number: String, name: String, teamName: String, pointValue: Int, cost: Int) {
        self.number = number
        self.name = name
        self.teamName = teamName
        self.pointValue = pointValue
        self.cost = cost
    }
    
}

public func ==(lhs: Player, rhs: Player) -> Bool {
    return lhs.name == rhs.name
}
    
