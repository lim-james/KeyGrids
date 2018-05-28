//
//  CGPointExtension.swift
//  KeyGrids
//
//  Created by James on 28/5/18.
//  Copyright © 2018 james. All rights reserved.
//

import UIKit

extension CGPoint {
    func isIn(_ frame: CGRect) -> Bool {
        return x >= frame.origin.x && x <= frame.origin.x + frame.width && y >= frame.origin.y && y <= frame.origin.y + frame.height
    }
    
    func distance(from point: CGPoint) -> CGFloat {
        return sqrt((x - point.x) * (x - point.x) + (y - point.y) * (y - point.y))
    }
}
