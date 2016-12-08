//
//  RankedUser.swift
//  CL
//
//  Created by iwritecode on 12/4/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//

import Foundation


class RankedUser {
    var rank: Int

    var username: String
    var points: Int
    
    init(rank: Int, username: String, points: Int) {
        self.rank = rank
        self.username = username
        self.points = points
    }
    
}