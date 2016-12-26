//
//  Game.swift
//  CL
//
//  Created by iwritecode on 12/24/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//

import Foundation


class Game {
    
    var gameID: String?
    var category: String?
    var team1: Team?
    var team2: Team?
    var startingValue: Int?
    var latitude: Float?
    var longitude: Float?
    var venue: String?
    var endRegistration: NSDate?
    
    init() {}
    
    init(gameID: String?, category: String?, team1: Team?, team2: Team?, startingValue: Int?, latitude: Float?, longitude: Float?, venue: String?, endRegistration: NSDate?) {
        self.gameID = gameID
        self.category = category
        self.team1 = team1
        self.team2 = team2
        self.startingValue = startingValue
        self.latitude = latitude
        self.longitude = longitude
        self.venue = venue
        self.endRegistration = endRegistration
    }
    
}