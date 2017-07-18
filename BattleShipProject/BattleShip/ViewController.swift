//
//  ViewController.swift
//  BattleShip
//
//  Created by C4Q  on 7/14/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var brain: battleBrain?
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBAction func resetBoard(_ sender: Any) {
        brain = battleBrain()
        messageLabel.text = ""
        setupButtons()
    }
    override func viewDidLoad() {
        brain = battleBrain()
        view.backgroundColor = UIColor.gray
        setupButtons()
    }
    
    private func setupButtons() {
        view.subviews.forEach{if $0 is ShipButton {$0.removeFromSuperview()}}
        var xOffSet: CGFloat = 40
        var yOffSet: CGFloat = 0
        for x in 0..<10 {
            yOffSet = 100
            for y in 0..<10 {
                let newButton = ShipButton(frame: CGRect(x: xOffSet, y: yOffSet, width: 25, height: 25))
                newButton.x = x
                newButton.y = y
                newButton.backgroundColor = .cyan
                newButton.addTarget(self, action: #selector(attackSquare), for: .touchUpInside)
                view.addSubview(newButton)
                yOffSet += 30
            }
            xOffSet += 30
        }
    }
    
    func attackSquare(_ sender: ShipButton) {
        guard let x = sender.x, let y = sender.y else {
            return
        }
        print("guessing at x:\(x) and y:\(y)")
        switch brain!.attackSquare(x: x, y: y) {
        case .miss:
            messageLabel.text = "Miss!"
            sender.backgroundColor = .white
        case .hit:
            messageLabel.text = "Hit!"
            sender.backgroundColor = .red
        case .alreadyGuessed:
            messageLabel.text = "You've already guessed this square"
        case .sunk(let shipName):
            sender.backgroundColor = .red
            messageLabel.text = "You sunk my \(shipName)"
            if brain!.allShipsSunk {
                messageLabel.text = "You win!"
            }
        }
    }
}

