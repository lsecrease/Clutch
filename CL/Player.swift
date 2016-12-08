//
//  Player.swift
//  CL
//
//  Created by iwritecode on 11/27/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//

import Foundation

class Player: NSObject {
    
    var number: String
    var name: String
    var teamName: String
    var pointValue: Int
    var cost: Int
    
    required init(number: String, name: String, teamName: String, pointValue: Int, cost: Int) {
        self.number = number
        self.name = name
        self.teamName = teamName
        self.pointValue = pointValue
        self.cost = cost
    }
    
}