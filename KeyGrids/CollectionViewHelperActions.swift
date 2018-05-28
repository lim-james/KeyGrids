//
//  CollectionViewHelperAction.swift
//  KeyGrids
//
//  Created by James on 28/5/18.
//  Copyright © 2018 james. All rights reserved.
//

import UIKit

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func setupMenuCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: tileLength, height: tileLength)
        menuCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
        menuCollectionView.backgroundColor = .background
        menuCollectionView.register(TileCollectionViewCell.self, forCellWithReuseIdentifier: "MenuCell")
        menuCollectionView.translatesAutoresizingMaskIntoConstraints = false
        menuView.addSubview(menuCollectionView)
        
        let top = NSLayoutConstraint(item: menuCollectionView, attribute: .top, relatedBy: .equal, toItem: menuView, attribute: .top, multiplier: 1, constant: 0)
        let left = NSLayoutConstraint(item: menuCollectionView, attribute: .left, relatedBy: .equal, toItem: menuView, attribute: .left, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint(item: menuCollectionView, attribute: .right, relatedBy: .equal, toItem: menuView, attribute: .right, multiplier: 1, constant: 0)
        menuView.addConstraints([top, left, right])
    }
    
    func setupActionCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: tileLength, height: tileLength)
        actionCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        actionCollectionView.delegate = self
        actionCollectionView.dataSource = self
        actionCollectionView.backgroundColor = .background
        actionCollectionView.register(TileCollectionViewCell.self, forCellWithReuseIdentifier: "ActionCell")
        actionCollectionView.translatesAutoresizingMaskIntoConstraints = false
        menuView.addSubview(actionCollectionView)
        
        let top = NSLayoutConstraint(item: actionCollectionView, attribute: .top, relatedBy: .equal, toItem: menuCollectionView, attribute: .bottom, multiplier: 1, constant: 0)
        let left = NSLayoutConstraint(item: actionCollectionView, attribute: .left, relatedBy: .equal, toItem: menuView, attribute: .left, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint(item: actionCollectionView, attribute: .right, relatedBy: .equal, toItem: menuView, attribute: .right, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: actionCollectionView, attribute: .bottom, relatedBy: .equal, toItem: menuView, attribute: .bottom, multiplier: 1, constant: 0)
        let height = NSLayoutConstraint(item: menuCollectionView, attribute: .height, relatedBy: .equal, toItem: actionCollectionView, attribute: .height, multiplier: 3, constant: 1)
        menuView.addConstraints([top, left, right, bottom, height])
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == menuCollectionView ? notes.count : directions.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = TileCollectionViewCell()
        if collectionView == menuCollectionView {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: indexPath) as! TileCollectionViewCell
            cell.note = notes[indexPath.row]
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActionCell", for: indexPath) as! TileCollectionViewCell
            if indexPath.row < directions.count {
                cell.direction = directions[indexPath.row]
            } else {
                cell.setupTile()
                let bot = Bot()
                bot.create(with: tileLength, at: CGPoint.zero, duration: 0)
                cell.addSubview(bot)
            }
        }
        cell.layer.borderColor = UIColor.borderColor.cgColor
        cell.layer.borderWidth = 1
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: tileLength, height: tileLength)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            cell.alpha = 1
        }, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let tile = selectedTile {
            if collectionView == menuCollectionView {
                notes[indexPath.row].play(with: Float32(timeInterval))
                tile.note = notes[indexPath.row]
            } else {
                if indexPath.row < directions.count {
                    tile.direction = directions[indexPath.row]
                } else {
                    createBot(at: tile.position)
                }
            }
            let cell = collectionView.cellForItem(at: indexPath)
            collectionView.bringSubview(toFront: cell!)
            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
                cell?.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }) { _ in
                UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
                    cell?.transform = CGAffineTransform(scaleX: 1, y: 1)
                }, completion: nil)
            }
        }
    }
}
