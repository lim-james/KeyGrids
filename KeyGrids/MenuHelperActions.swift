//
//  MenuHelperAction.swift
//  KeyGrids
//
//  Created by James on 28/5/18.
//  Copyright © 2018 james. All rights reserved.
//

import UIKit

extension ViewController {
    func hideMenu() {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
            self.menuView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            self.menuView.alpha = 0
        }) { _ in
            self.menuView.isHidden = true
        }
    }
    
    func showMenu() {
        menuView.isHidden = false
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
            self.menuView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.menuView.alpha = 1
        }, completion: nil)
    }
    
    func toggleMenu(from tile: Tile) {
        if tile == selectedTile {
            if menuView.isHidden {
                selectedTile = tile
            } else {
                selectedTile = nil
            }
        } else {
            selectedTile = tile
        }
    }
}
