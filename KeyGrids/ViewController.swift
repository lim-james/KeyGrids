//
//  ViewController.swift
//  KeyGrids
//
//  Created by James on 28/5/18.
//  Copyright © 2018 james. All rights reserved.
//

import UIKit
import AudioToolbox

class ViewController: UIViewController {

    var firstLaunch = true
    
    var tileLength: CGFloat! {
        return gridContainer.frame.width / CGFloat(gridSize)
    }
    
    var previousLocation: CGPoint!
    
    var hoveredTile: Tile! {
        didSet {
            if let tile = hoveredTile {
                if bots.count != 0 {
                    gridContainer.insertSubview(tile, belowSubview: bots.first!)
                } else {
                    gridContainer.bringSubview(toFront: tile)
                }
            }
            
            grid.forEach { (row) in
                row.forEach({ (tile) in
                    if tile == hoveredTile { tile.expand() }
                })
            }
        }
    }
    
    var selectedTile: Tile! {
        didSet {
            if selectedTile == nil {
                hideMenu()
            } else {
                showMenu()
            }
            
            grid.forEach { (row) in
                row.forEach({ (tile) in
                    if tile == selectedTile {
                        tile.expand()
                    } else {
                        tile.contract()
                    }
                })
            }
        }
    }
    
    // grid variables
    
    let gridContainer = UIView()
    let gridSize: Int = 8
    var grid: [[Tile]] = []
    var saved: [[Properties]] = []
    
    // bot variables
    
    var bots: [Bot] = []
    var selectedBot: Bot? {
        didSet {
            if selectedBot != nil { showDeleteLabel() }
            else { hideDeleteLabel() }
        }
    }
    
    // slider variables
    
    let sliderView = UISlider()
    let sliderLabel = UILabel()
    
    var tps: Int! {
        didSet {
            sliderView.value = Float(tps)
            sliderLabel.text = "\(tps!) tiles/s"
            sliderLabel.sizeToFit()
            timeInterval = 1/Double(tps)
            
            if timer != nil {
                if timer.isValid {
                    timer.invalidate()
                    timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(self.refresh), userInfo: nil, repeats: true)
                }
            }
        }
    }
    var timeInterval: Double = 0.25
    var timer: Timer!
    
    // start button variables
    
    let startButton = UIButton()
    
    // menu variables
    
    var directions: [Direction] = [.none, .up, .down, .left, .right]
    
    let menuView = UIView()
    var menuCollectionView: UICollectionView!
    var actionCollectionView: UICollectionView!
    
    // delete variables
    
    let deleteLabel = UILabel()
    
    // clear variables
    let clearButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        readNotesFile()
        
        saved = [
            [
                Properties(direction: .right, note: notes[0]),
                Properties(direction: .none, note: notes[62]),
                Properties(direction: .none, note: notes[64]),
                Properties(direction: .none, note: notes[67]),
                Properties(direction: .none, note: notes[69]),
                Properties(direction: .none, note: notes[69]),
                Properties(direction: .none, note: notes[66]),
                Properties(direction: .up, note: notes[66])
            ],
            [
                Properties(direction: .none, note: notes[66]),
                Properties(direction: .down, note: notes[0]),
                Properties(direction: .right, note: notes[0]),
                Properties(direction: .down, note: notes[64]),
                Properties(direction: .right, note: notes[66]),
                Properties(direction: .down, note: notes[66]),
                Properties(direction: .right, note: notes[69]),
                Properties(direction: .none, note: notes[66])
            ],
            [
                Properties(direction: .none, note: notes[66]),
                Properties(direction: .none, note: notes[66]),
                Properties(direction: .none, note: notes[0]),
                Properties(direction: .none, note: notes[64]),
                Properties(direction: .none, note: notes[64]),
                Properties(direction: .none, note: notes[0]),
                Properties(direction: .none, note: notes[62]),
                Properties(direction: .none, note: notes[66])
            ],
            [
                Properties(direction: .none, note: notes[66]),
                Properties(direction: .none, note: notes[64]),
                Properties(direction: .none, note: notes[67]),
                Properties(direction: .none, note: notes[66]),
                Properties(direction: .none, note: notes[0]),
                Properties(direction: .none, note: notes[66]),
                Properties(direction: .none, note: notes[64]),
                Properties(direction: .none, note: notes[67])
            ],
            [
                Properties(direction: .none, note: notes[0]),
                Properties(direction: .none, note: notes[62]),
                Properties(direction: .none, note: notes[67]),
                Properties(direction: .none, note: notes[66]),
                Properties(direction: .none, note: notes[69]),
                Properties(direction: .none, note: notes[66]),
                Properties(direction: .none, note: notes[66]),
                Properties(direction: .none, note: notes[67])
            ],
            [
                Properties(direction: .none, note: notes[66]),
                Properties(direction: .none, note: notes[69]),
                Properties(direction: .none, note: notes[67]),
                Properties(direction: .none, note: notes[66]),
                Properties(direction: .none, note: notes[0]),
                Properties(direction: .none, note: notes[66]),
                Properties(direction: .none, note: notes[0]),
                Properties(direction: .none, note: notes[67])
            ],
            [
                Properties(direction: .none, note: notes[66]),
                Properties(direction: .none, note: notes[66]),
                Properties(direction: .none, note: notes[67]),
                Properties(direction: .none, note: notes[66]),
                Properties(direction: .none, note: notes[66]),
                Properties(direction: .none, note: notes[0]),
                Properties(direction: .none, note: notes[0]),
                Properties(direction: .none, note: notes[67])
            ],
            [
                Properties(direction: .down, note: notes[66]),
                Properties(direction: .left, note: notes[0]),
                Properties(direction: .down, note: notes[67]),
                Properties(direction: .left, note: notes[66]),
                Properties(direction: .down, note: notes[66]),
                Properties(direction: .left, note: notes[66]),
                Properties(direction: .down, note: notes[0]),
                Properties(direction: .left, note: notes[67])
            ]
        ]
        
        view.backgroundColor = .background
        
        if firstLaunch {
            setupGridContainer()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if firstLaunch {
            setupMenuView()
            setupMenuCollectionView()
            setupActionCollectionView()
            generateGrid()
            setupStartButton()
            setupSliderView()
            setupSliderLabel()
            setupDeleteLabel()
            setupClearButton()
            
            createBot(at: CGPoint.zero)
            grid[0][0].direction = .right
            
            firstLaunch = false
            
            loadGrid()
        }
    }
    
    func setupGridContainer() {
        gridContainer.backgroundColor = .clear
        gridContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(gridContainer)
        
        let top = NSLayoutConstraint(item: gridContainer, attribute: .top, relatedBy: .equal, toItem: view, attribute: .topMargin, multiplier: 1, constant: 0)
        let left = NSLayoutConstraint(item: gridContainer, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint(item: gridContainer, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0)
        let height = NSLayoutConstraint(item: gridContainer, attribute: .height, relatedBy: .equal, toItem: gridContainer, attribute: .width, multiplier: 1, constant: 0)
        
        view.addConstraints([top, left, right, height])
    }
    
    func setupMenuView() {
        menuView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(menuView)
        
        let top = NSLayoutConstraint(item: menuView, attribute: .top, relatedBy: .equal, toItem: gridContainer, attribute: .bottom, multiplier: 1, constant: 20)
        let left = NSLayoutConstraint(item: menuView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .leftMargin, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint(item: menuView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .rightMargin, multiplier: 1, constant: 0)
        let height = NSLayoutConstraint(item: menuView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: tileLength * 4)
        view.addConstraints([top, left, right, height])
        
        hideMenu()
    }
    
    func setupStartButton() {
        startButton.setImage(UIImage(named: "play"), for: .normal)
        startButton.imageView?.contentMode = .scaleAspectFit
        startButton.imageEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8)
        startButton.addTarget(self, action: #selector(self.startAction), for: .touchUpInside)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(startButton)
        
        let left = NSLayoutConstraint(item: startButton, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint(item: startButton, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: startButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: isiPhoneX() ? -20 : 0)
        let height = NSLayoutConstraint(item: startButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 2, constant: isiPhoneX() ? tileLength * 1.25 : tileLength)
        view.addConstraints([left, right, bottom, height])
    }
    
    func setupSliderView() {
        sliderView.minimumValue = 1
        sliderView.minimumTrackTintColor = .white
        sliderView.maximumValue = 20
        sliderView.maximumTrackTintColor = .clear
        sliderView.addTarget(self, action: #selector(self.sliderAction(_:)), for: .allEvents)
        sliderView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sliderView)
        
        tps = 5
        
        let left = NSLayoutConstraint(item: sliderView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 20)
        let bottom = NSLayoutConstraint(item: sliderView, attribute: .bottom, relatedBy: .equal, toItem: startButton, attribute: .top, multiplier: 1, constant: 0)
        
        view.addConstraints([left, bottom])
    }
    
    func setupSliderLabel() {
        sliderLabel.textColor = .white
        sliderLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sliderLabel)
        
        let left = NSLayoutConstraint(item: sliderLabel, attribute: .left, relatedBy: .equal, toItem: sliderView, attribute: .right, multiplier: 1, constant: 20)
        let right = NSLayoutConstraint(item: sliderLabel, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: -20)
        let bottom = NSLayoutConstraint(item: sliderLabel, attribute: .bottom, relatedBy: .equal, toItem: startButton, attribute: .top, multiplier: 1, constant: 0)
        let height = NSLayoutConstraint(item: sliderLabel, attribute: .height, relatedBy: .equal, toItem: sliderView, attribute: .height, multiplier: 1, constant: 0)
        
        view.addConstraints([left, right, bottom, height])
    }
    
    func setupDeleteLabel() {
        hideDeleteLabel()
        deleteLabel.text = "DELETE BOT"
        deleteLabel.textColor = .red
        deleteLabel.textAlignment = .center
        deleteLabel.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(deleteLabel, belowSubview: gridContainer)
        
        let top = NSLayoutConstraint(item: deleteLabel, attribute: .top, relatedBy: .equal, toItem: gridContainer, attribute: .bottom, multiplier: 1, constant: 20)
        let left = NSLayoutConstraint(item: deleteLabel, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint(item: deleteLabel, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0)
        let height = NSLayoutConstraint(item: deleteLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: tileLength)
        view.addConstraints([top, left, right, height])
    }
    
    func setupClearButton() {
        clearButton.setImage(UIImage(named: "delete"), for: .normal)
        clearButton.imageView?.contentMode = .scaleAspectFit
        clearButton.imageEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8)
        clearButton.addTarget(self, action: #selector(self.clearAction), for: .touchUpInside)
        clearButton.backgroundColor = .background
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(clearButton, belowSubview: gridContainer)
        
        let top = NSLayoutConstraint(item: clearButton, attribute: .top, relatedBy: .equal, toItem: gridContainer, attribute: .bottom, multiplier: 1, constant: 20)
        let left = NSLayoutConstraint(item: clearButton, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint(item: clearButton, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0)
        let height = NSLayoutConstraint(item: clearButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: tileLength)
        view.addConstraints([top, left, right, height])
    }
    
    func hideDeleteLabel() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.deleteLabel.alpha = 0
            self.deleteLabel.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            self.deleteLabel.backgroundColor = .background
            self.deleteLabel.textColor = .red
        }) { _ in
            self.showClearButton()
        }
    }
    
    func highlightDeleteLabel() {
        hideClearButton()
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.deleteLabel.alpha = 1
            self.deleteLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.deleteLabel.backgroundColor = .red
            self.deleteLabel.textColor = .white
        }, completion: nil)
    }
    
    func showDeleteLabel() {
        hideClearButton()
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.deleteLabel.alpha = 1
            self.deleteLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.deleteLabel.backgroundColor = .background
            self.deleteLabel.textColor = .red
        }, completion: nil)
    }
    
    func generateGrid() {
        for x in 0 ..< gridSize {
            var row: [Tile] = []
            for y in 0 ..< gridSize {
                let tile = Tile()
                tile.create(with: tileLength, at: CGPoint(x: x, y: y))
                gridContainer.addSubview(tile)
                row.append(tile)
                tile.fadeIn()
            }
            grid.append(row)
        }
    }
    
    func clearGrid() {
        for row in grid {
            for tile in row {
                tile.fadeOut({ _ in
                    tile.removeFromSuperview()
                    if tile == self.grid.last?.last {
                        self.grid.removeAll()
                        self.generateGrid()
                    }
                })
            }
        }
    }
    
    func saveGrid() {
        saved.removeAll()
        print("\nGird Format: [")
        grid.forEach { (row) in
            var savedRow: [Properties] = []
            print("\t[")
            row.forEach({ (tile) in
                let noteIndex = notes.index(where: { (note) -> Bool in
                    return note.index == tile.note.index
                })
                savedRow.append(Properties(direction: tile.direction, note: tile.note))
                print("\t\tProperties(direction: \(tile.direction.rawValue), note: notes[\(noteIndex!)]),")
            })
            saved.append(savedRow)
            print("\t],")
        }
        print("]")
    }
    
    func loadGrid() {
        for r in 0 ..< grid.count {
            let row = grid[r]
            for t in 0 ..< row.count {
                row[t].direction = saved[r][t].direction
                row[t].note = saved[r][t].note
            }
        }
    }
    
    func createBot(at position: CGPoint) {
        let bot = Bot()
        bot.create(with: tileLength, at: position, duration: timeInterval)
        bots.append(bot)
        gridContainer.addSubview(bot)
    }
    
    func delete(_ bot: Bot) {
        bot.fadeOut { _ in
            bot.removeFromSuperview()
            self.bots.remove(at: self.bots.index(of: bot)!)
        }
    }
    
    func resetBots() {
        for bot in bots {
            bot.reset()
        }
    }
    
    func clearBots() {
        for bot in bots {
            delete(bot)
        }
    }
    
    @objc func createAction() {
        createBot(at: selectedTile.position)
    }
    
    @objc func startAction() {
        if startButton.image(for: .normal) == UIImage(named: "play") {
            selectedTile = nil
            timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(self.refresh), userInfo: nil, repeats: true)
            startButton.setImage(UIImage(named: "rewind"), for: .normal)
            saveGrid()
        } else {
            timer.invalidate()
            startButton.setImage(UIImage(named: "play"), for: .normal)
            resetBots()
        }
    }
    
    @objc func clearAction() {
        let alertController = UIAlertController(title: "Clear grid?", message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let yes = UIAlertAction(title: "Ok", style: .default) { _ in
            self.clearGrid()
            self.clearBots()
        }
        alertController.addAction(cancel)
        alertController.addAction(yes)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func sliderAction(_ sender: UISlider) {
        tps = Int(sender.value)
    }
    
    func hideClearButton() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
                self.clearButton.alpha = 0
                self.clearButton.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }) { _ in
                self.clearButton.isHidden = true
            }
        }
    }
    
    func showClearButton() {
        DispatchQueue.main.async {
            self.clearButton.isHidden = false
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
                self.clearButton.alpha = 1
                self.clearButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
        }
    }
    
    @objc func refresh() {
        for bot in bots {
            bot.move(inside: grid)
        }
    }
    
    func dismissAction() {
        selectedTile = nil
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
}

