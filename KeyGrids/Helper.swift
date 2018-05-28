//
//  Helper.swift
//  KeyGrids
//
//  Created by James on 28/5/18.
//  Copyright © 2018 james. All rights reserved.
//

import UIKit

func * (point: CGPoint, length: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * length, y: point.y * length)
}

func isiPhoneX() -> Bool {
    return UIScreen.main.nativeBounds.height == 2436
}
