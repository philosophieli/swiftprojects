//
//  BoardButtons.swift
//  FinalProject
//
//  Created by Sophie Li on 5/10/15.
//  Based on a tutorial from https://www.makeschool.com/tutorials/learn-swift-by-example/p1
//  Copyright (c) 2015 Sophie Li. All rights reserved.
//

import UIKit

class BoardButtons: UIButton {

    var square:Square
    let size:CGFloat
    let margin:CGFloat
    
    init(asquare:Square, asize:CGFloat, amargin:CGFloat) {
        self.square = asquare
        self.size = asize
        self.margin = amargin
        let x = CGFloat(self.square.col) * (asize + amargin)
        let y = CGFloat(self.square.row) * (asize + amargin)
        let theFrame = CGRectMake(x, y, asize, asize)
        super.init(frame: theFrame)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getButtonDisplay() {
        if !self.square.isMine {
            if self.square.neighboringMines == 0 {
                self.setBackgroundImage(UIImage(named: "White"), forState: .Normal)
            }
            else {
                self.setTitle("\(self.square.neighboringMines)", forState: .Normal)
            }
        }
        else {
            self.setBackgroundImage(UIImage(named: "Bomb"), forState: .Normal)
        }
    }
    
    
}

class Board: NSObject {
    let size:Int
    var squares:[[Square]] = []
    
    init(size:Int) {
        self.size = size
        
        for row in 0 ..< size {
            var squareRow:[Square] = []
            for col in 0 ..< size {
                let square = Square(row: row, col: col)
                squareRow.append(square)
            }
            squares.append(squareRow)
        }
    }
    
    func calculateIsMine(square: Square) {
        square.isMine = ((arc4random()%8) == 0)
    }
    
    func calculateNeighborMines(square: Square) {
        let neighbors = getNeighbors(square)
        var neighboringMines = 0
        for neighborSquare in neighbors {
            if neighborSquare.isMine {
                neighboringMines++
            }
        }
        square.neighboringMines = neighboringMines
    }
    
    func resetBoard() {
        for row in 0 ..< size {
            for col in 0 ..< size {
                squares[row][col].isClicked = false
                self.calculateIsMine(squares[row][col])
            }
        }
        for row in 0 ..< size {
            for col in 0 ..< size {
                self.calculateNeighborMines(squares[row][col])
            }
        }
    }
    
    func squaresInBounds(row : Int, col : Int) -> Square? {
        if row >= 0 && row < self.size && col >= 0 && col < self.size {
            return squares[row][col]
        } else {
            return nil
        }
    }
    
    func getNeighbors(square : Square) -> [Square] {
        var neighbors:[Square] = []
        var neighboringMines = 0
        let adjacents = [(-1,-1),(-1,0),(0,-1),(1,-1),(-1,1),(1,0),(0,1),(1,1)]
        for (rows,cols) in adjacents {
            let possibleNeighbor:Square? = squaresInBounds(square.row+rows, col: square.col+cols)
            if let neighbor = possibleNeighbor {
                neighbors.append(neighbor)
            }
        }
        return neighbors
    }
    
}

class Square: NSObject {
    let row:Int
    let col:Int
    
    var neighboringMines = 0
    var isMine = false
    var isClicked = false
    
    init(row:Int, col:Int) {
        self.row = row
        self.col = col
    }
}