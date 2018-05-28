//
//  Direction.swift
//  KeyGrids
//
//  Created by James on 28/5/18.
//  Copyright © 2018 james. All rights reserved.
//

import UIKit

enum Direction {
    case up
    case down
    case left
    case right
    case none
    
    var rawValue: String {
        switch self {
        case .up:
            return ".up"
        case .down:
            return ".down"
        case .left:
            return ".left"
        case .right:
            return ".right"
        case .none:
            return ".none"
        }
    }
}
