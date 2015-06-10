//
//  gameTile.swift
//  MineHuntSwift
//
//  Created by Jonathan French on 28/05/2015.
//  Copyright (c) 2015 Jonathan French. All rights reserved.
//

import UIKit
import SpriteKit

protocol tileDelegate:class {
    func checkFlag()->Bool
}


class gameTile: SKSpriteNode {
    
    enum TileState {
        case kTileStateTouched
        case kTileStateUnTouched
    }
    
    var tex: SKTexture?
    var smokeTrail : SKEmitterNode?
    var soundAction : SKAction?
    var tileSize : CGRect?
    var tileTap : Int
    var width : Int?
    var xpos : Int?
    var ypos : Int?
    var arrayCol : Int?
    var arrayRow : Int?
    var state : TileState?
    var numHints : Int?
    var hasFlag : Bool
    var hasMine : Bool
    var hasHint : Bool
    var gameOver : Bool
    var hasQuestion : Bool
    var delegate:tileDelegate?
    var blankTile : UIImage?
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize) {
        hasFlag = false;
        hasMine = false;
        hasHint = false;
        numHints=0;
        gameOver = false;
        hasQuestion=false;
        tileTap=0;
        state = TileState.kTileStateUnTouched
        tileSize = CGRect(x: 0, y: 0, width: 46, height: 46)
        var col = UIColor.redColor()
        var s:CGSize = CGSize(width: 46,height: 46)
        super.init(texture: texture, color: col, size: s)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    func initWithPositionX(x :Int, y :Int, row :Int, col :Int, tilesize :Int)//->gameTile
    {
        let ts : CGSize = CGSize(width: tilesize, height: tilesize)
        tileSize = CGRect(x: 0, y: 0, width: tilesize, height: tilesize)
        blankTile = MineHuntImages.imageOfBlank(frame: tileSize!)
        tex = SKTexture(image: MineHuntImages.imageOfBlank(frame: tileSize!))
        NSLog("init texture at %d, %d", x,y)
        arrayCol = col;
        arrayRow = row;
        xpos = x
        ypos = y
        width = tilesize
        var s:CGSize = CGSize(width: tilesize,height: tilesize)
        self.size = s
        self.xScale = 1;
        self.yScale = 1;
        self.position = CGPointMake(CGFloat(x), CGFloat(y))
        self.userInteractionEnabled = true;
        //self.color = UIColor.redColor()
        self.texture = tex
       // return self;
    }
    
    func getHint()->Int{
        return numHints!
    }
    
    func setHint(hint :Int){
        numHints = hint
        hasFlag = false
        hasMine = false
    }
    
    func setMine(mine : Bool){
        hasMine = mine
        hasFlag = false
        hasHint = false
        numHints = 0
    }
    
    func setFlag(flag : Bool){
        hasFlag = flag
    }
    
    func showHint(){
        // check if we've already been here
        if hasHint || hasFlag {
            return;
        }
        
        hasHint = true;
        
        if (numHints == 0)
        {
            tex = SKTexture.init(image: MineHuntImages.imageOfEmpty(frame: tileSize!))
            // we don't really want to display a 0
            // but we do need to check our surroundings for other space!
            NSNotificationCenter.defaultCenter().postNotificationName("emptyTile", object: self)
        }
        else{
            tex = SKTexture.init(image: MineHuntImages.imageOfBombCount(frame: tileSize!, numBombs: String( numHints!)))
        }
        self.texture = tex
        
    }
    
    func showLetter(letter : String)
    {
        tex = SKTexture.init(image: MineHuntImages.imageOfBombCount(frame: tileSize!, numBombs: letter))
        self.texture = tex
    }
    
    func showTile(){
        tex = SKTexture.init(image: MineHuntImages.imageOfBlank(frame: tileSize!))
        self.texture = tex
        hasQuestion = false;
        hasFlag = false;
    }
    
    func showQuestion()
    {
        tex = SKTexture.init(image: MineHuntImages.imageOfQuestion(frame: tileSize!))
        self.texture = tex
        hasQuestion = true
        hasFlag = false
        NSNotificationCenter.defaultCenter().postNotificationName("questButton", object: self)
    }
    
    func showFlag(){
        // check that all the flags available havent been planted. Use the delegate call back to GameScene
        if (!delegate!.checkFlag()) {
            return
        }
        
        if (!hasHint){
            tex = SKTexture.init(image: MineHuntImages.imageOfFlag(frame: tileSize!))
            self.texture = tex
            hasFlag = true
            hasQuestion = false
            NSNotificationCenter.defaultCenter().postNotificationName("checkFlags", object: self)
        }
    }
    
    func showBomb(expcount :Float){
        tex = SKTexture.init(image: MineHuntImages.imageOfMine(frame: tileSize!))
        self.texture = tex

        var timer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(expcount), target: self, selector: Selector("explosion"), userInfo: nil, repeats: false)
    }
    
    func explosion(){
        
        soundAction = SKAction.playSoundFileNamed("explosion.caf", waitForCompletion: false)
        runAction(soundAction)
        tex = SKTexture.init(image: MineHuntImages.imageOfExplosion(frame: tileSize!))
        self.texture = tex
        let smokepath = NSBundle.mainBundle().pathForResource("spark", ofType: "sks")
        smokeTrail = NSKeyedUnarchiver.unarchiveObjectWithFile(smokepath!) as? SKEmitterNode
        smokeTrail!.position = self.position
        self.parent!.addChild(smokeTrail!)
    }
    
    func showExplosion(){
        self.explosion()
        NSNotificationCenter.defaultCenter().postNotificationName("gameOver", object: self)
    }
    
    // #pragma mark touch
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if (gameOver){
            return
        }
        
        if (state != TileState.kTileStateUnTouched){
            return
        }
        ++tileTap
        state = TileState.kTileStateTouched
    }
    
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        if (gameOver){
            return
        }
        state = TileState.kTileStateUnTouched
        NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: Selector("taphandler"), userInfo: nil, repeats: false)
    }
    
    
    func taphandler(){
        if(tileTap==0){ return
        }
        switch (tileTap) {
        case 1:
            // Single tap
            if hasFlag {
                self.showQuestion()
                return
            }
            
            if hasQuestion {
                self.showTile()
                return
            }
            
            if hasMine {
                self.showExplosion()
            }
            else {
                self.showHint()
            }
        case 2:
            // double tap
            if hasFlag {
                return
            }
            if hasQuestion {
                showTile()
            }
            else {
                showFlag()
            }
        default:
            NSLog("taps")
        }
        tileTap=0;
    }
    
}
