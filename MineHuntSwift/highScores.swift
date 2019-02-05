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
    
    func newScore(_ timerTime:Int32,gameType:Int)
    {
        scoreArray = getHighScores(gameType)
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-YYY"
        
        for i in 0...9{
            let hs : highScore = scoreArray[i]
            if timerTime < hs.time{
                let newHS : highScore = highScore()
                newHS.date = dateFormatter.string(from: Date())
                newHS.time = timerTime
                scoreArray.insert(newHS, at: i)
                scoreArray.removeLast()
                saveHighScores(gameType)
                return
            }
        }
        
    }
    
    func getHighScores(_ gameType:Int) ->Array<highScore>
    {
        let keyName = "scores" + String(gameType)

        let dateFormatter : DateFormatter = DateFormatter()
        let standardDefaults:UserDefaults = UserDefaults.standard
        
        dateFormatter.dateFormat = "dd-MM-YYY"
        
        if let data = standardDefaults.data(forKey: keyName){
            
            scoreArray = NSKeyedUnarchiver.unarchiveObject(with: data) as! [highScore]
        }
        else{
            for _ in 0...9{
                let hs :highScore = highScore()
                hs.time = 3600
                hs.date = dateFormatter.string(from: Date())
                scoreArray.append(hs)
            }
            saveHighScores(gameType)
        }
        return scoreArray
    }
    
    func saveHighScores(_ gameType:Int){
        let keyName = "scores" + String(gameType)
        let standardDefaults:UserDefaults = UserDefaults.standard
        let enc = NSKeyedArchiver.archivedData(withRootObject: scoreArray)
        standardDefaults.set(enc, forKey: keyName)
        standardDefaults.synchronize()
    }
    
}

class highScore : NSObject,NSCoding {
    var time:Int32=0
    var date:String = ""
    
    required init?(coder aDecoder: NSCoder)
    {
        time = aDecoder.decodeCInt(forKey: "gametime")
        date = aDecoder.decodeObject(forKey: "gamedate") as! String
    }
    
    override init(){
        
    }
    
    func encode(with encoder:NSCoder)
    {
        encoder.encodeCInt(Int32(time), forKey: "gametime")
        encoder.encode(String(date), forKey:"gamedate")
    
    }
    
    
}

