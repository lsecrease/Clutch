//
//  DeviceType.swift
//  CL
//
//  Created by iwritecode on 12/30/16.
//  Copyright © 2016 iwritecode. All rights reserved.
//

import Foundation

struct DeviceType {
    static let isIphone4s = UIScreen.main.bounds.size.height == 480
    static let isIphone5 = UIScreen.main.bounds.size.height == 568
    static let isIphone6Plus = UIScreen.main.bounds.size.height == 736
}
