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
    
    init(teamDict: [String:AnyObject]){
        print(teamDict)
        
        let teamName = teamDict["name"] as? String ?? ""
        self.name = teamName

        if let teamPlayers = teamDict["players"] as? [String: AnyObject]{
            print(teamPlayers)
            for player in teamPlayers {
                let currentPlayer = Player(playerDict: player)
                self.players.append(currentPlayer)
            }
        }
    }
}
