//
//  TouchHelperAction.swift
//  KeyGrids
//
//  Created by James on 28/5/18.
//  Copyright © 2018 james. All rights reserved.
//

import UIKit

extension ViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let location = touches.first?.location(in: gridContainer)
        previousLocation = location
        
        if !(location?.isIn(gridContainer.bounds))! {
            selectedBot = nil
            selectedTile = nil
            hoveredTile = nil
        }
        
        for bot in bots {
            if (location?.isIn(bot.frame))! {
                selectedBot = bot
                selectedTile = nil
                return
            }
        }
        
        for row in grid {
            for tile in row {
                if (location?.isIn(tile.frame))! {
                    selectedBot = nil
                    hoveredTile = tile
                    break
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        let location = touches.first?.location(in: gridContainer)
        if (location?.distance(from: previousLocation))! > CGFloat(tileLength / 5) {
            if let bot = selectedBot {
                var frame = deleteLabel.frame
                if isiPhoneX() {
                    frame.origin.y -= deleteLabel.frame.height
                }
                if (location?.isIn(frame))! {
                    highlightDeleteLabel()
                } else {
                    showDeleteLabel()
                }
                bot.center = location!
            } else if let tile = hoveredTile {
                selectedTile = nil
                tile.center = location!
            }
        }
    }
    
    func clip(bot: Bot) {
        var x = round(bot.frame.origin.x / tileLength)
        x = x < 0 ? 0 : x
        x = x >= CGFloat(gridSize) ? CGFloat(gridSize) - 1 : x
        
        var y = round(bot.frame.origin.y / tileLength)
        y = y < 0 ? 0 : y
        y = y >= CGFloat(gridSize) ? CGFloat(gridSize) - 1 : y
        
        bot.startPosition = CGPoint(x: x, y: y)
    }
    
    func getNewPosition(of tile: Tile) -> CGPoint {
        var x = round(tile.frame.origin.x / tileLength)
        x = x < 0 ? 0 : x
        x = x >= CGFloat(gridSize) ? CGFloat(gridSize) - 1 : x
        
        var y = round(tile.frame.origin.y / tileLength)
        y = y < 0 ? 0 : y
        y = y >= CGFloat(gridSize) ? CGFloat(gridSize) - 1 : y
        
        return CGPoint(x: x, y: y)
    }
    
    func endAction(with location: CGPoint) {
        if let bot = selectedBot {
            if location.isIn(deleteLabel.frame) {
                delete(bot)
            } else {
                clip(bot: bot)
            }
            selectedBot = nil
        } else if let tile = hoveredTile {
            if location.isIn(clearButton.frame) {
                let old = tile.position
                tile.position = old
                tile.direction = .none
                tile.note = Note()
                hoveredTile = nil
            } else {
                let new = getNewPosition(of: tile)
                if tile.position == new {
                    tile.position = new
                    toggleMenu(from: tile)
                } else {
                    let old = tile.position
                    let switchedTile = grid[Int(new.x)][Int(new.y)]
                    switchedTile.position = old
                    tile.position = new
                    grid[Int(old.x)][Int(old.y)] = switchedTile
                    grid[Int(new.x)][Int(new.y)] = tile
                    hoveredTile = nil
                }
            }
        } else {
            dismissAction()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        endAction(with: (touches.first?.location(in: gridContainer))!)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
}
