//
//  Player.swift
//  CL
//
//  Created by iwritecode on 11/27/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//

import Foundation

public struct Player: Equatable {
    
    var name : String?
    var number : Int?
    var pointValue : Float?
    var score : Float?
    var playerID : String?
    
    init() {}
    
    init(name: String, number: Int, pointValue: Float, score: Float) {
        self.name = name
        self.number = number
        self.pointValue = pointValue
        self.score = score
    }
    init (playerDict: (key: String, value: AnyObject)){
        print(playerDict)
        self.playerID = playerDict.key
        
        if let playerDetails = playerDict.1 as? [String:AnyObject]{
            self.number = playerDetails["number"] as? Int ?? nil
            self.name = playerDetails["name"] as? String ?? ""
            self.pointValue = playerDetails["pointValue"] as? Float ?? nil
            self.score = playerDetails["score"] as? Float ?? nil
        
//            if let safeNumber = playerDetails["number"] as? Int{
//                self.number = safeNumber
//            }
//            if let safePointValue = playerDetails["pointValue"] as? Float{
//                self.pointValue = safePointValue
//            }
//            if let safeScore = playerDetails["score"] as? Float{
//                self.score = safeScore
//            }
        
        }
    }
}

public func ==(lhs: Player, rhs: Player) -> Bool {
    return lhs.name == rhs.name && lhs.number == rhs.number && lhs.pointValue == rhs.pointValue
}
    
