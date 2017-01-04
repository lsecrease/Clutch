//
//  TestData.swift
//  CL
//
//  Created by iwritecode on 11/27/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//

import Foundation

// Players 

let players: [Player] = [
    Player(name: "Devin Thomas", number: "2", pointValue: 41, score: 5),
    Player(name: "Greg McClinton", number: "11", pointValue: 39, score: 11),
    Player(name: "Chase Jeter", number: "2", pointValue: 37, score: 3),
    Player(name: "Luke Kennard", number: "5", pointValue: 34, score: 25),
    Player(name: "Doral Moore", number: "4", pointValue: 32, score: 4),
    Player(name: "Grayson Allen", number: "3", pointValue: 29, score: 17)
    
]



// Ranked Users

let RankedUsers: [RankedUser] = [
    RankedUser(rank: 1, username: "User name1", points: 212),
    RankedUser(rank: 2, username: "User name2", points: 99),
    RankedUser(rank: 3, username: "User name3", points: 93),
    RankedUser(rank: 4, username: "User name4", points: 89),
    RankedUser(rank: 5, username: "User name5", points: 85),
    RankedUser(rank: 6, username: "User name6", points: 81),
    RankedUser(rank: 7, username: "User name7", points: 75),
    RankedUser(rank: 8, username: "User name8", points: 67)

]

// GameMatchup Matchups

let GameMatchups: [GameMatchup] = [
    GameMatchup(homeTeam: "Duke", awayTeam: "Wake Forest", venue: "Comcast Arena", date: "Thurs, September 9", time: "10:00pm"),
    GameMatchup(homeTeam: "Univ. Virginia", awayTeam: "Univ. Maryland", venue: "Comcast Arena", date: "Fri, September 10", time: "8:30pm"),
    GameMatchup(homeTeam: "Georgetown", awayTeam: "UCLA", venue: "Comcast Arena", date: "Wed, September 22", time: "9:30pm"),
    GameMatchup(homeTeam: "Marquette", awayTeam: "Vanderbilt", venue: "Comcast Arena", date: "Thurs, September 23", time: "9;30pm"),
    GameMatchup(homeTeam: "Marshall", awayTeam: "Notre Dame", venue: "Comcast Arena", date: "Fri, September 24", time: "7:30pm"),
    GameMatchup(homeTeam: "Towson", awayTeam: "George Mason", venue: "Comcast Arena", date: "Wed, September 29", time: "4:00pm")
]