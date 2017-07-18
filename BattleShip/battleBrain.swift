//
//  battleBrain.swift
//  BattleShip
//
//  Created by C4Q  on 7/14/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation


struct Point {
    let x: Int
    let y : Int
}

struct Ship {
    var position: [Point]
    var name: String
    var size: Int
}

enum boardSquare {
    case unhitEmpty
    case hitEmpty
    case unhitShip
    case hitShip
}

enum hitOutcome {
    case hit
    case miss
    case alreadyGuessed
    case sunk(String)
}

class battleBrain {
    
    var allShipsSunk: Bool {
        for ship in ships {
            for point in ship.position {
                switch board[point.y][point.x] {
                case .hitShip:
                    continue
                default:
                    return false
                }
            }
        }
        return true
    }
    
    init() {
        setupShipsAndBoard()
        printShips()
    }
    
    func attackSquare(x: Int, y: Int) -> hitOutcome {
        guesses.append(Point(x: x, y: y))
        switch board[y][x] {
        case .hitEmpty:
            return .alreadyGuessed
        case .unhitEmpty:
            board[y][x] = boardSquare.hitEmpty
            return .miss
        case .hitShip:
            return .alreadyGuessed
        case .unhitShip:
            board[y][x] = boardSquare.hitShip
            let point = Point(x: x, y: y)
            guard let ship = identifyShipAt(point) else {
                print("THIS SHOULD NEVER HAPPEN")
                return .miss
            }
            var shipIsSunk = true
            for point in ship.position {
                if board[point.y][point.x] != boardSquare.hitShip {
                    shipIsSunk = false
                }
            }
            return shipIsSunk ? .sunk(ship.name) : .hit
        }
    }
    
    private var ships: [Ship] = []
    private var board: [[boardSquare]] = Array(repeating: Array(repeating: .unhitEmpty, count: 10), count: 10)
    private var guesses: [Point] = []

    
    private func printShips() {
        for ship in ships {
            print(ship.name)
            print(ship.position)
        }
    }
    
    private func identifyShipAt(_ point: Point) -> Ship? {
        for ship in ships {
            let a = ship.position
            for shipPoint in a {
                if shipPoint.x == point.x && shipPoint.y == point.y {
                    return ship
                }
            }
        }
        return nil
    }
    
    private func setupShipsAndBoard() {
        let aircraftCarrier = Ship(position: [], name: "AircraftCarrier", size: 5)
        let battleship = Ship(position: [], name: "Battleship", size: 4)
        let cruiser = Ship(position: [], name: "Cruiser", size: 3)
        let submarine = Ship(position: [], name: "Submarine", size: 3)
        let destroyer = Ship(position: [], name: "Destroyer", size: 2)
        let ships = [aircraftCarrier, battleship, cruiser, submarine, destroyer]
        
        ships.forEach{placeShip($0)}
    }
    
    private func placeShip(_ ship: Ship) {
        let size = ship.size
        let orientationIsHorizontal = [true, false][Int(arc4random_uniform(2))]
        var shipIsPlaced = false
        placementLoop: while !shipIsPlaced {
            print("Starting Loop")
            let lastAvilablePosition = 10 - size  //could be buggy
            let randX = Int(arc4random_uniform(UInt32(orientationIsHorizontal ? lastAvilablePosition : 10)))
            let randY = Int(arc4random_uniform(UInt32(orientationIsHorizontal ? 10 : lastAvilablePosition)))
            switch board[randY][randX] {
            case .unhitEmpty:
                //verify the rest of the spaces are open
                var points = [Point]()
                for offSet in 0..<size {
                    switch board[randY + (orientationIsHorizontal ? 0 : offSet)][randX + (orientationIsHorizontal ? offSet : 0)] {
                    case .unhitEmpty:
                        points.append(Point(x: randX + (orientationIsHorizontal ? offSet : 0), y: randY + (orientationIsHorizontal ? 0 : offSet)))
                    default:
                        continue placementLoop
                    }
                }
                ships.append(Ship(position: points, name: ship.name, size: ship.size))
                for point in points {
                    board[point.y][point.x] = boardSquare.unhitShip
                }
                shipIsPlaced = true
            default:
                continue placementLoop
            }
        }
    }
}
