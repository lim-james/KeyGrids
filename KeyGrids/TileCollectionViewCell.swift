//
//  TileCollectionViewCell.swift
//  KeyGrids
//
//  Created by James on 28/5/18.
//  Copyright © 2018 james. All rights reserved.
//

import UIKit

class TileCollectionViewCell: UICollectionViewCell {
    let tile = Tile()
    
    var note: Note! {
        didSet {
            tile.create(with: note)
            setupTile()
        }
    }
    
    var direction: Direction! {
        didSet {
            tile.create(with: direction)
            setupTile()
        }
    }
    
    func setupTile() {
        tile.translatesAutoresizingMaskIntoConstraints = false
        addSubview(tile)
        
        let top = NSLayoutConstraint(item: tile, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: tile, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let left = NSLayoutConstraint(item: tile, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint(item: tile, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0)
        addConstraints([top, bottom, left, right])
    }
}
