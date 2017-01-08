//
//  Team.swift
//  CL
//
//  Created by iwritecode on 11/27/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//

import Foundation


class Team {
    
    var name = String()
    var players = [Player]()
    
    init() {}
    
    init(name: String, players: [Player]) {
        self.name = name
        self.players = players
    }
}