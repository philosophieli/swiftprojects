//
//  ViewController.swift
//  FinalProject
//
//  Created by Sophie Li on 5/10/15.
//  Based on a tutorial from https://www.makeschool.com/tutorials/learn-swift-by-example/p1
//  Copyright (c) 2015 Sophie Li. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    
    @IBOutlet weak var boardView: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var boardSize: Int = 12
    var marginSize: CGFloat = 0
    var board: Board
    var buttons:[BoardButtons] = []
    var aTimer:NSTimer?
    
    required init(coder aDecoder: NSCoder) {
        self.board = Board(size: boardSize)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeBoard()
        resetBoard()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func newGameButton() {
        resetBoard()
    }
    
    func resetBoard() {
        board.resetBoard()
        time = 0
        score = 0
        for squareButton in buttons {
            squareButton.setBackgroundImage(UIImage(named: "Background"), forState: .Normal)
            squareButton.setTitle("", forState: .Normal)
        }
        aTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("incTime"), userInfo: nil, repeats: true)
        endGame()

    }
    func incTime() {
            time++
    }
    func makeBoard() {
        for row in 0 ..< board.size {
            for col in 0 ..< board.size {
                let square = board.squares[row][col]
                let squareSize : CGFloat = self.boardView.frame.width / CGFloat(boardSize)
                let aButton = BoardButtons(asquare: square, asize: squareSize, amargin: marginSize)
                aButton.addTarget(self, action: "buttonPressed:", forControlEvents: .TouchUpInside)
                aButton.setBackgroundImage(UIImage(named: "Background"), forState: .Normal)
                self.boardView.addSubview(aButton)
                self.buttons.append(aButton)
            }
        }
    }
    
    func endGame() {
        aTimer = nil
    }
    
    func minePressed() {
        var alertView = UIAlertView()
        alertView.addButtonWithTitle("New Game")
        alertView.title = "You Lost :C"
        alertView.message = "You tapped on a mine."
        alertView.show()
        alertView.delegate = self
        endGame()
    }
    
    var score:Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
            scoreLabel.sizeToFit()
        }
    }
    var time:Int = 0  {
        didSet {
            timeLabel.text = "Time: \(time)"
            timeLabel.sizeToFit()
        }
    }
    
    func alertView(View: UIAlertView!, clickedButtonAtIndex buttonIndex: Int) {
        self.resetBoard()
    }
    
    func buttonPressed(sender: BoardButtons!) {
        if sender.square.isMine {
            minePressed()
        }
        if (!sender.square.isClicked) {
            sender.square.isClicked = true
            sender.getButtonDisplay()
            score++
        }
    }
    
    
}

