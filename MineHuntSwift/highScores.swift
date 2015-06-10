//
//  highScores.swift
//  MineHuntSwift
//
//  Created by Jonathan French on 29/05/2015.
//  Copyright (c) 2015 Jonathan French. All rights reserved.
//

import UIKit

class highScores: NSObject {

    var scoreArray = [highScore]()
    
    func newScore(timerTime:Int32,gameType:Int)
    {
        scoreArray = getHighScores(gameType)
        let dateFormatter : NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYY"
        
        for i in 0...9{
            let hs : highScore = scoreArray[i]
            if timerTime < hs.time{
                let newHS : highScore = highScore()
                newHS.date = dateFormatter.stringFromDate(NSDate())
                newHS.time = timerTime
                scoreArray.insert(newHS, atIndex: i)
                scoreArray.removeLast()
                saveHighScores(gameType)
                return
            }
        }
        
    }
    
    func getHighScores(gameType:Int) ->Array<highScore>
    {
        let keyName = "scores" + String(gameType)

        let dateFormatter : NSDateFormatter = NSDateFormatter()
        let standardDefaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        dateFormatter.dateFormat = "dd-MM-YYY"
        
        if var data = standardDefaults.dataForKey(keyName){
            
            scoreArray = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [highScore]
        }
        else{
            for i in 0...9{
                var hs :highScore = highScore()
                hs.time = 3600
                hs.date = dateFormatter.stringFromDate(NSDate())
                scoreArray.append(hs)
            }
            saveHighScores(gameType)
        }
        return scoreArray
    }
    
    func saveHighScores(gameType:Int){
        var keyName = "scores" + String(gameType)
        let standardDefaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let enc = NSKeyedArchiver.archivedDataWithRootObject(scoreArray)
        standardDefaults.setObject(enc, forKey: keyName)
        standardDefaults.synchronize()
    }
    
}

class highScore : NSObject,NSCoding {
    var time:Int32=0
    var date:String = ""
    
    required init(coder aDecoder: NSCoder)
    {
        time = aDecoder.decodeIntForKey("gametime")
        date = aDecoder.decodeObjectForKey("gamedate") as! String
    }
    
    override init(){
        
    }
    
    func encodeWithCoder(encoder:NSCoder)
    {
        encoder.encodeInt(Int32(time), forKey: "gametime")
        encoder.encodeObject(String(date), forKey:"gamedate")
    
    }
    
//    func initWithCoder(decoder :NSCoder )
//    {
//        time = decoder.decodeIntForKey("gametime")
//        date = (decoder.decodeObjectForKey("gamedate") as? String)!
//
//    }
    
    
}

