//
//  User.swift
//  CL
//
//  Created by iwritecode on 12/4/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//

import Foundation

class User {
    
    var name: String?
    var email: String?
    var userId: String?
    var pointsAvailable: Int?
    var score: Float?
    var disqualified: Bool?
    var roster = [String]()
    
    init() {}
    
    
    init(userDict: (key:String, value:AnyObject)){
        self.userId = userDict.key
        if let userDetails = userDict.value as? [String:AnyObject]{
            self.name = userDetails["name"] as? String ?? ""
            self.email = userDetails["email"] as? String ?? ""
            self.pointsAvailable = userDetails["score"] as? Int ?? nil
            self.disqualified = userDetails["disqualified"] as? Bool ?? nil
            
            self.roster = userDetails["roster"] as? [String] ?? []
        }
        
    }
    
    
}
