//
//  Tile.swift
//  KeyGrids
//
//  Created by James on 28/5/18.
//  Copyright © 2018 james. All rights reserved.
//

import UIKit

class Tile: UIView {
    var position = CGPoint() {
        didSet {
            contract()
            UIView.animate(withDuration: 0.25) {
                self.frame.origin = self.position * self.frame.width
            }
        }
    }
    
    var note: Note! {
        didSet {
            let dir = direction; direction = dir
            noteLabel.text = note.name
            UIView.animate(withDuration: 0.25) {
                self.noteLabel.backgroundColor = self.note.color
            }
        }
    }
    
    var direction: Direction = .none {
        didSet {
            if direction != .none {
                directionView.image = UIImage(named: "\(direction).png")?.withRenderingMode(.alwaysTemplate)
                directionView.tintColor = note.name == "" ? .white : .black
            } else {
                directionView.image = UIImage()
                directionView.tintColor = .black
            }
        }
    }
    
    let noteLabel = UILabel()
    let directionView = UIImageView()
    
    func create(with note: Note) {
        position = CGPoint.zero
        setupNoteLabel()
        setupDirectionView()
        
        self.note = note
    }
    
    func create(with direction: Direction) {
        position = CGPoint.zero
        setupNoteLabel()
        setupDirectionView()
        
        self.direction = direction
    }
    
    func create(with length: CGFloat, at point: CGPoint) {
        frame.size = CGSize(width: length, height: length)
        position = point
        backgroundColor = .background
        
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.borderColor.cgColor
        
        setupNoteLabel()
        setupDirectionView()
    }
    
    func setupNoteLabel() {
        note = Note()
        noteLabel.backgroundColor = .clear
        noteLabel.textAlignment = .center
        noteLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(noteLabel)
        
        let top = NSLayoutConstraint(item: noteLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: noteLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let left = NSLayoutConstraint(item: noteLabel, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint(item: noteLabel, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0)
        
        addConstraints([top, bottom, left, right])
    }
    
    func setupDirectionView() {
        directionView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(directionView)
        let bottom = NSLayoutConstraint(item: directionView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint(item: directionView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0)
        let width = NSLayoutConstraint(item: directionView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.5, constant: 0)
        let height = NSLayoutConstraint(item: directionView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.5, constant: 0)
        
        addConstraints([bottom, right, width, height])
    }
    
    func expand() {
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.75, options: .curveEaseOut, animations: {
            self.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }, completion: nil)
    }
    
    func contract() {
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.75, options: .curveEaseOut, animations: {
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: nil)
    }
    
    func fadeIn() {
        alpha = 0
        UIView.animate(withDuration: 0.5, delay: Double(position.x + position.y) / 20, options: .curveEaseIn, animations: {
            self.alpha = 1
        }, completion: nil)
    }
    
    func fadeOut(_ completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: 0.5, delay: Double(position.x + position.y) / 20, options: .curveEaseIn, animations: {
            self.alpha = 0
        }, completion: completion)
    }
}
