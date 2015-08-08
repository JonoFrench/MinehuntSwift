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
 
    let timeLabel : SKLabelNode?
    let flagLabel : SKLabelNode?
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
        timeLabel = SKLabelNode(fontNamed: "Marker Felt")
        timeLabel!.text = "Time: 0:00";
        timeLabel!.fontSize = 24;
        timeLabel!.position = CGPointMake(30,30);
        timeLabel!.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        
        flagLabel = SKLabelNode(fontNamed: "Marker Felt")
        flagLabel!.text = "Flag: 0";
        flagLabel!.fontSize = 24;
        flagLabel!.position = CGPointMake(210,30);
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
        timeLabel = SKLabelNode(fontNamed: "Marker Felt")
        timeLabel!.text = "Time: 0:00";
        timeLabel!.fontSize = 24;
        timeLabel!.position = CGPointMake(30,30);
        timeLabel!.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Left
        
        flagLabel = SKLabelNode(fontNamed: "Marker Felt")
        flagLabel!.text = "Flag: 0";
        flagLabel!.fontSize = 24;
        flagLabel!.position = CGPointMake(210,30);
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
    
    override func didMoveToView(view: SKView) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"emptyTileNotification:", name: "emptyTile", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"gameOverNotification:", name: "gameOver", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"checkFlagsNotification:", name: "checkFlags", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"questButtonNotification:", name: "questButton", object: nil)
        screenWidth = view.bounds.size.width
        screenHeight = view.bounds.size.height
        self.addChild(timeLabel!)
        self.addChild(flagLabel!)
    
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
        let clockTimer : NSTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "timerShowTick:", userInfo: nil, repeats: true)
        let runLoop : NSRunLoop = NSRunLoop.currentRunLoop()
        runLoop.addTimer(clockTimer, forMode: NSDefaultRunLoopMode)
    }
    
    func setGame(){
        let tileSize : Int = Int(screenWidth!) / numCols
        let startpos : Int = Int (screenHeight!) - (tileSize / 2)
        horizontalStart = (Int(screenWidth!) - (tileSize * numCols)) / 2
        for var x1 = 0; x1 < numRows; ++x1{
            var colArray : Array<gameTile> = []
            for var y1 = 0; y1 < numCols; ++y1{
                let gt : gameTile = gameTile()
                gt.initWithPositionX(horizontalStart + (tileSize/2)+(y1*tileSize), y: startpos-(x1*tileSize), row: x1, col: y1,tilesize: tileSize)
                gt.delegate = self
                colArray.append(gt)
                self.addChild(gt)
            }
            mineArray.append(colArray)
        }
        
        // Set Mines
        for var mines = 0; mines < numBombs; ++mines{
            let x = arc4random() % UInt32( numRows)
            let y = arc4random() % UInt32( numCols)
            let gt : gameTile = mineArray[Int(x)][Int(y)]
            if !gt.hasMine{
                gt.setMine(true)
            }
            else{
                --mines
            }
        }
        
        //Set Hints
        
        for var x1 = 0; x1 < numRows; ++x1{
            for var y1 = 0; y1 < numCols; ++y1{
                let gt : gameTile = mineArray[Int(x1)][Int(y1)]
                if !gt.hasMine{
                    let c = getHint(x1, col: y1)
                    gt.setHint(c)
                }
            }
        }
        
        
    }
 
    
    func getHint(row :Int, col :Int)->Int{
        var hint :Int = 0
        let startCol : Int = max(0, col-1)
        let endCol : Int = min(numCols-1,col+1)
        let startRow : Int = max(0,row-1)
        let endRow : Int = min(numRows-1,row+1)
        
        for var r = startRow; r <= endRow;++r{
            for var c = startCol; c <= endCol; ++c{
                let gt : gameTile = mineArray[r][c]
                if gt.hasMine {
                    ++hint
                }
            }
        }
        return hint
    }
    
    func checkAround(row :Int, col :Int){
        let startCol : Int = max(0, col-1)
        let endCol : Int = min(numCols-1,col+1)
        let startRow : Int = max(0,row-1)
        let endRow : Int = min(numRows-1,row+1)
        
        for var r = startRow; r <= endRow;++r{
            for var c = startCol; c <= endCol; ++c{
                let gt : gameTile = mineArray[r][c]
                if !gt.hasMine && !gt.hasHint{
                    gt.showHint()
                }
            }
        }
    }
    
    func gameReturn(){
        self.view?.presentScene(nil)
        NSNotificationCenter.defaultCenter().postNotificationName("menuReturn", object: nil)
    }
    
    
    
    func emptyTileNotification(notification : NSNotification){
        let gt :gameTile = (notification.object as? gameTile)!
        checkAround(gt.arrayRow!, col: gt.arrayCol!)
    }
    
    func questButtonNotification(notification : NSNotification){
        ++flagCounter
        flagNumber()
    }
    
    func timerShowTick(timer : NSTimer){
        if !gameOver
        {
            ++timerTime
        }
        let sec = timerTime % 60
        let min = timerTime / 60
        timeLabel?.text = String(format: "Time: %d:%02d",min,sec)
    }
    
    func flagNumber(){
        flagLabel?.text = "Flag: \(flagCounter)"
    }
    
    func gameOverNotification(notification :NSNotification )
    {
        var expcount : Float  = 0.25;
        
        for var x1 = 0; x1 < numRows; ++x1{
            for var y1 = 0; y1 < numCols; ++y1{
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
        gameOverButton.userInteractionEnabled = true
        gameOverButton.setTouchUpInsideTarget(self,action: Selector("gameReturn"))
        gameOverButton.setTouchUpTarget(self,action: Selector("gameReturn"))
        self.addChild(gameOverButton)
    }
 
    
    func checkFlagsNotification(notification : NSNotification ){
        --flagCounter
        flagNumber()
        var c : Int=0
        for var x1 = 0; x1 < numRows; ++x1{
            for var y1 = 0; y1 < numCols; ++y1{
                let gt : gameTile = mineArray[Int(x1)][Int(y1)]
                if gt.hasMine && gt.hasFlag{
                    ++c
                }
            }
        }
            
    if c == numBombs {
        gameOver = true;
    //add the score to the highscore
        let hs : highScores = highScores()
        hs.newScore(timerTime, gameType: self.gameType)
        let gameOverButton : gameButton = gameButton()
        let btnImage :UIImage = MineHuntImages.imageOfWon(frame: CGRect(x: 0, y: 0, width: screenWidth!/2, height: (screenWidth!/2)/3))
        gameOverButton.texture = SKTexture(image: btnImage)
        gameOverButton.size = btnImage.size
        gameOverButton.position = CGPoint(x: screenWidth!/2, y: 50+(screenWidth!/2)/3)
        gameOverButton.userInteractionEnabled = true
        gameOverButton.setTouchUpInsideTarget(self,action: Selector("gameReturn"))
        gameOverButton.setTouchUpTarget(self,action: Selector("gameReturn"))
        
        self.addChild(gameOverButton)
        }
    }
    
    // delegate functions
    
    func checkFlag()->Bool{
        return flagCounter == 0 ?false:true
    }
    
    
}


