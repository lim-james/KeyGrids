//
//  Bot.swift
//  KeyGrids
//
//  Created by James on 28/5/18.
//  Copyright © 2018 james. All rights reserved.
//

import UIKit

class Bot: UIView {
    var startPosition: CGPoint! {
        didSet {
            position = startPosition
        }
    }
    
    var position: CGPoint! {
        didSet {
            UIView.animate(withDuration: speed) {
                self.frame.origin = self.position * self.frame.width
            }
        }
    }
    
    var direction: Direction = .none
    var speed: Double = 0
    var head = UIView()
    
    func create(with length: CGFloat, at point: CGPoint, duration: Double) {
        frame.size = CGSize(width: length, height: length)
        startPosition = point
        speed = duration
        
        setupHead()
    }
    
    func setupHead() {
        head.backgroundColor = .botColor
        head.translatesAutoresizingMaskIntoConstraints = false
        addSubview(head)
        
        let width = NSLayoutConstraint(item: head, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.5, constant: 0)
        let height = NSLayoutConstraint(item: head, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.5, constant: 0)
        let centerX = NSLayoutConstraint(item: head, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let centerY = NSLayoutConstraint(item: head, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        addConstraints([width, height, centerX, centerY])
        
        head.layer.cornerRadius = self.frame.height/4
        head.clipsToBounds = true
    }
    
    func reset() {
        position = startPosition
    }
    
    func move(inside grid: [[Tile]]) {
        let tile = grid[Int(position.x)][Int(position.y)]
        let nextDirection = tile.direction
        if nextDirection != .none {
            direction = nextDirection
        }
        
        switch direction {
        case .up:
            if position.y > 0 {
                position.y -= 1
            }
        case .down:
            if position.y < CGFloat(grid[0].count - 1) {
                position.y += 1
            }
        case .left:
            if position.x > 0 {
                position.x -= 1
            }
        case .right:
            if position.x < CGFloat(grid.count - 1) {
                position.x += 1
            }
        default:
            break
        }
        
        tile.note.play(with: Float32(speed))
    }
    
    func fadeOut(_ completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: 0.5, delay: Double(position.x + position.y) / 20, options: .curveEaseIn, animations: {
            self.alpha = 0
        }, completion: completion)
    }
}
