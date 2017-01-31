//
//  Constants.swift
//  CL
//
//  Created by iwritecode on 11/27/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//

import Foundation

// MARK: Google Maps API

// MARK: - NSUserDefaults

let avatarKey = "avatar"
let avatarURLKey = "avatarURL"
let emailKey = "email"
let nameKey = "name"

// MARK: UI

let defaultFont = UIFont.systemFont(ofSize: 16.0)


struct Constants {
    
    struct Segues {
        static let loginToMain = "loginToMain"
        static let loginToAdmin = "loginToAdmin"
        static let showUpdatePointsVC = "showUpdatePointsVC"
    }
    
}

enum Direction {
    case right, left
}

enum RotationDirection {
    case clockwise, counterClockwise
}

enum CategoryType {
    case mlb, mls, ncaaBasketball, ncaaFootball, nba, nfl, nhl
}
