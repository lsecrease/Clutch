//
//  Game.swift
//  CL
//
//  Created by iwritecode on 12/24/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//

import Foundation


class Game {
    
    var gameID = String()
    var category = String()
    var team1 = Team()
    var team2 = Team()
    var startingValue : Int?
    var latitude : Float?
    var longitude : Float?
    var venue = String()
    var gameStartTime : Date?
    var endRegistration : Date?
    var endGameTime : Date?
    var participants = [User]()

    
    init() {}
    
    init(gameID: String, category: String, team1: Team, team2: Team, startingValue: Int, latitude: Float, longitude: Float, venue: String, endRegistration: Date, participants: [String]) {
        self.gameID = gameID
        self.category = category
        self.team1 = team1
        self.team2 = team2
        self.startingValue = startingValue
        self.latitude = latitude
        self.longitude = longitude
        self.venue = venue
        self.endRegistration = endRegistration
        self.participants = []
    }
    
    init(gameDict: (key:String, value: AnyObject)) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"


        print(gameDict)
        self.gameID = gameDict.key
        if let gameDetails = gameDict.1 as? [String:AnyObject] {
            
            self.category = gameDetails["category"] as? String ?? ""
            self.venue = gameDetails["venue"] as? String ?? ""
            self.startingValue = gameDetails["startingValue"] as? Int ?? nil
            //initializing times data
            if let startTime = gameDetails["startTime"] as? String{
                self.gameStartTime = dateFormatter.date(from: startTime)
            }
            if let endRegistration = gameDetails["endRegistrationTime"] as? String{
                self.endRegistration = dateFormatter.date(from: endRegistration)
            }
            if let endGameTime = gameDetails["endGameTime"] as? String{
                self.endGameTime = dateFormatter.date(from: endGameTime)
            }
            //initializing location data
            if let locationDetails = gameDetails["location"] as? [String: AnyObject]{
                self.latitude = locationDetails["lat"] as? Float ?? nil
                self.longitude = locationDetails["lon"] as? Float ?? nil
            }
            //initializing team data
            if let team1Details = gameDetails["team1"] as? [String: AnyObject]{
                team1 = Team(teamDict: team1Details)
            }
            if let team2Details = gameDetails["team2"] as? [String: AnyObject]{
                team2 = Team(teamDict: team2Details)
            }
            //initializing user data
            if let participants = gameDetails["participants"] as? [String: AnyObject]{
                for user in participants{
                    let currentUser = User(userDict: user)
                    self.participants.append(currentUser)
                }
            }
            
        }
    }
    
}
