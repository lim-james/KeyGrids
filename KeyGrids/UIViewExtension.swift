//
//  UIViewExtension.swift
//  KeyGrids
//
//  Created by James on 28/5/18.
//  Copyright © 2018 james. All rights reserved.
//

import UIKit

extension UIView {
    func overlapHitTest(_ point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        if !self.isUserInteractionEnabled || self.isHidden || self.alpha == 0 {
            return nil
        }
        
        var hitView: UIView? = self
        if !self.point(inside: point, with: event) {
            if self.clipsToBounds {
                return nil
            } else {
                hitView = nil
            }
        }
        
        for subview in self.subviews.reversed() {
            let insideSubview = self.convert(point, to: subview)
            if let sview = subview.overlapHitTest(insideSubview, withEvent: event) {
                return sview
            }
        }
        return hitView
    }
}
