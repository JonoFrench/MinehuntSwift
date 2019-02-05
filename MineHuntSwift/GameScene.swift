//
//  GameScene.swift
//  MineHuntSwift
//
//  Created by Jonathan French on 28/05/2015.
//  Copyright (c) 2015 Jonathan French. All rights reserved.
//

import UIKit
import SpriteKit

class GameScene: SKScene, tileDelegate {
 
    let timeLabel : SKLabelNode = SKLabelNode(fontNamed: "Marker Felt")
    let flagLabel : SKLabelNode = SKLabelNode(fontNamed: "Marker Felt")
    var gameType : Int
    var mineArray : Array<Array<gameTile>> = []
    var flagCounter :Int
    var bombNumber :Int
    var numBombs :Int
    var numRows :Int
    var numCols :Int
    var timerTime :Int32
    var horizontalStart : Int
    var screenWidth : CGFloat?
    var screenHeight : CGFloat?
    var gameOver : Bool
    
    override init(size: CGSize) {
        timeLabel.text = "Time: 0:00";
        timeLabel.fontSize = 24;
        timeLabel.position = CGPoint(x: 30,y: 30);
        timeLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        flagLabel.text = "Flag: 0";
        flagLabel.fontSize = 24;
        flagLabel.position = CGPoint(x: 210,y: 30);
        gameType = 0
        flagCounter = 0
        bombNumber = 0
        gameOver = false
        numRows = 0
        numBombs = 0
        timerTime = 0
        numCols = 0
        horizontalStart = 0
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        timeLabel.text = "Time: 0:00";
        timeLabel.fontSize = 24;
        timeLabel.position = CGPoint(x: 30,y: 30);
        timeLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        flagLabel.text = "Flag: 0";
        flagLabel.fontSize = 24;
        flagLabel.position = CGPoint(x: 210,y: 30);
        gameType = 0
        flagCounter = 0
        bombNumber = 0
        gameOver = false
        numRows = 0
        numBombs = 0
        timerTime = 0
        numCols = 0
        horizontalStart = 0
        super.init(coder: aDecoder)
    }
    
    override func didMove(to view: SKView) {
        NotificationCenter.default.addObserver(self, selector:#selector(GameScene.emptyTileNotification(_:)), name: NSNotification.Name(rawValue: "emptyTile"), object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(GameScene.gameOverNotification(_:)), name: NSNotification.Name(rawValue: "gameOver"), object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(GameScene.checkFlagsNotification(_:)), name: NSNotification.Name(rawValue: "checkFlags"), object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(GameScene.questButtonNotification(_:)), name: NSNotification.Name(rawValue: "questButton"), object: nil)
        screenWidth = view.bounds.size.width
        screenHeight = view.bounds.size.height
        self.addChild(timeLabel)
        self.addChild(flagLabel)
    
        switch gameType {
        case 0:
            numBombs=10
            numRows=8
            numCols = 8
        case 1:
            numBombs=14
            numRows=12
            numCols = 12
        case 2:
            numBombs=24
            numRows=16
            numCols = 16
        default:
            numBombs=10
            numRows=8
            numCols = 8
        }
        
        timerTime = 0
        flagCounter = numBombs
        gameOver = false
        self.setGame()
        let clockTimer : Timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameScene.timerShowTick(_:)), userInfo: nil, repeats: true)
        let runLoop : RunLoop = RunLoop.current
        runLoop.add(clockTimer, forMode: RunLoopMode.defaultRunLoopMode)
    }
    
    func setGame(){
        let tileSize : Int = Int(screenWidth!) / numCols
        let startpos : Int = Int (screenHeight!) - (tileSize / 2)-70
        horizontalStart = (Int(screenWidth!) - (tileSize * numCols)) / 2
        for x1 in 0 ..< numRows {
            var colArray : Array<gameTile> = []
            for y1 in 0 ..< numCols {
                let gt : gameTile = gameTile()
                gt.initWithPositionX(horizontalStart + (tileSize/2)+(y1*tileSize), y: startpos-(x1*tileSize), row: x1, col: y1,tilesize: tileSize)
                gt.delegate = self
                colArray.append(gt)
                self.addChild(gt)
            }
            mineArray.append(colArray)
        }
        
        // Set Mines

        var mines: Int = 0
        while mines < numBombs {
            let x = arc4random() % UInt32( numRows)
            let y = arc4random() % UInt32( numCols)
            let gt : gameTile = mineArray[Int(x)][Int(y)]
            if !gt.hasMine{
                mines += 1
                gt.setMine(true)
            }
        }
        
        //Set Hints
        
        for x1 in 0 ..< numRows {
            for y1 in 0 ..< numCols {
                let gt : gameTile = mineArray[Int(x1)][Int(y1)]
                if !gt.hasMine{
                    let c = getHint(x1, col: y1)
                    gt.setHint(c)
                }
            }
        }
    }
 
    
    func getHint(_ row :Int, col :Int)->Int{
        var hint :Int = 0
        let startCol : Int = max(0, col-1)
        let endCol : Int = min(numCols-1,col+1)
        let startRow : Int = max(0,row-1)
        let endRow : Int = min(numRows-1,row+1)
        
        for r in startRow ..< endRow+1 {
            for c in startCol ..< endCol+1 {
                let gt : gameTile = mineArray[r][c]
                if gt.hasMine {
                    hint += 1
                }
            }
        }
        return hint
    }
    
    func checkAround(_ row :Int, col :Int){
        let startCol : Int = max(0, col-1)
        let endCol : Int = min(numCols-1,col+1)
        let startRow : Int = max(0,row-1)
        let endRow : Int = min(numRows-1,row+1)
        
        for r in startRow ..< endRow + 1 {
            for c in startCol ..< endCol + 1 {
                let gt : gameTile = mineArray[r][c]
                if !gt.hasMine && !gt.hasHint{
                    gt.showHint()
                }
            }
        }
    }
    
    func gameReturn(){
        self.view?.presentScene(nil)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "menuReturn"), object: nil)
    }
    
    func emptyTileNotification(_ notification : Notification){
        let gt :gameTile = (notification.object as? gameTile)!
        checkAround(gt.arrayRow!, col: gt.arrayCol!)
    }
    
    func questButtonNotification(_ notification : Notification){
        flagCounter += 1
        flagNumber()
    }
    
    func timerShowTick(_ timer : Timer){
        if !gameOver
        {
            timerTime += 1
        }
        let sec = timerTime % 60
        let min = timerTime / 60

        timeLabel.text = String(format: "Time: %d:%02d",min,sec)
    }
    
    func flagNumber(){
        flagLabel.text = "Flag: \(flagCounter)"
    }
    
    func gameOverNotification(_ notification :Notification )
    {
        var expcount : Float  = 0.25;
        
        for x1 in 0 ..< numRows {
            for y1 in 0 ..< numCols {
                let gt : gameTile = mineArray[Int(x1)][Int(y1)]
                if !gt.gameOver && gt.hasMine{
                    gt.gameOver = true
                    gt.showBomb(expcount)
                    expcount += 0.25
                }
                gt.gameOver = true
            }
        }
        
        gameOver = true;
        let gameOverButton : gameButton = gameButton()
        let btnImage :UIImage = MineHuntImages.imageOfGameOver(frame: CGRect(x: 0, y: 0, width: screenWidth!/2, height: (screenWidth!/2)/3))
        gameOverButton.texture = SKTexture(image: btnImage)
        gameOverButton.size = btnImage.size
        gameOverButton.position = CGPoint(x: screenWidth!/2, y: 50+(screenWidth!/2)/3)
        gameOverButton.isUserInteractionEnabled = true
        gameOverButton.setTouchUpInsideTarget(self,action: #selector(GameScene.gameReturn))
        gameOverButton.setEnabled(true)
        self.addChild(gameOverButton)
    }
 
    
    func checkFlagsNotification(_ notification : Notification ){
        flagCounter -= 1
        flagNumber()
        var c : Int=0
        for x1 in 0 ..< numRows {
            for y1 in 0 ..< numCols {
                let gt : gameTile = mineArray[Int(x1)][Int(y1)]
                if gt.hasMine && gt.hasFlag{
                    c += 1
                }
            }
        }
            
    if c == numBombs {
        
        for x1 in 0 ..< numRows {
            for y1 in 0 ..< numCols {
                let gt : gameTile = mineArray[Int(x1)][Int(y1)]
                gt.gameOver = true
            }
        }
        
        gameOver = true;
    //add the score to the highscore
        let hs : highScores = highScores()
        hs.newScore(timerTime, gameType: self.gameType)
        let gameOverButton : gameButton = gameButton()
        let btnImage :UIImage = MineHuntImages.imageOfWon(frame: CGRect(x: 0, y: 0, width: screenWidth!/2, height: (screenWidth!/2)/3))
        gameOverButton.texture = SKTexture(image: btnImage)
        gameOverButton.size = btnImage.size
        gameOverButton.position = CGPoint(x: screenWidth!/2, y: 50+(screenWidth!/2)/3)
        gameOverButton.isUserInteractionEnabled = true
        gameOverButton.setTouchUpInsideTarget(self,action: #selector(GameScene.gameReturn))
        //gameOverButton.setTouchUpTarget(self,action: #selector(GameScene.gameReturn))
        gameOverButton.setEnabled(true)
        self.addChild(gameOverButton)
        }
    }
    
    // delegate functions
    
    func checkFlag()->Bool{
        return flagCounter == 0 ?false:true
    }
  
}


