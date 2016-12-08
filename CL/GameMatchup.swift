//
//  GameMatchup.swift
//  CL
//
//  Created by iwritecode on 12/5/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//

import Foundation


class GameMatchup: NSObject {
    
    var homeTeam: String
    var awayTeam: String
    var venue: String
    var date: String
    var time: String
    
    init(homeTeam: String, awayTeam: String, venue: String, date: String, time: String) {
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
        self.venue = venue
        self.date = date
        self.time = time
    }
    
}