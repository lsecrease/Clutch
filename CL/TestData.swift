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
    Player(number: "2", name: "Devin Thomas", teamName: "Wake Forest", pointValue: 41, cost: 10000),
    Player(number: "11", name: "Greg McClinton", teamName: "Wake Forest", pointValue: 39, cost: 8700),
    Player(number: "2", name: "Chase Jeter", teamName: "Duke", pointValue: 37, cost: 7000),
    Player(number: "5", name: "Luke Kennard", teamName: "Duke", pointValue: 34, cost: 5000),
    Player(number: "4", name: "Doral Moore", teamName: "Wake Forest", pointValue: 32, cost: 4900),
    Player(number: "3", name: "Grayson Allen", teamName: "Duke", pointValue: 29, cost: 4700)
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