//
//  Clock.swift
//  MineHuntSwift
//
//  Created by Jonathan French on 01/12/2015.
//  Copyright © 2015 Jonathan French. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit



class clock: SKSpriteNode {

    var timerTime : Int = 0

    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
     
        super.init(texture: texture, color: color, size: size)
        
    }

    required init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    
//    func setTime(_ t : Int)
//    {
//        timerTime = t
//        let sec = timerTime % 60
//        let min = timerTime / 60
//        let digitWidth = (self.frame.width / 9) * 2
//        let digitHeight = self.frame.height
//        let spacerWidth = self.frame.width / 9
//        let spacerHeight = self.frame.height
//        
//        
//        let clockImage : UIImageView = UIImageView(frame: self.frame)
//        
//    }
    
    func imageNumber (frame: CGRect, digit : Int)->UIImage {
        var image :UIImage
        
        switch digit {
        case 0:
            image = Numerals.imageOfNumber0(frame: frame)
        case 1:
            image = Numerals.imageOfNumber1(frame: frame)
        case 2:
            image = Numerals.imageOfNumber2(frame: frame)
        case 3:
            image = Numerals.imageOfNumber3(frame: frame)
        case 4:
            image = Numerals.imageOfNumber4(frame: frame)
        case 5:
            image = Numerals.imageOfNumber5(frame: frame)
        case 6:
            image = Numerals.imageOfNumber6(frame: frame)
        case 7:
            image = Numerals.imageOfNumber7(frame: frame)
        case 8:
            image = Numerals.imageOfNumber8(frame: frame)
        case 9:
            image = Numerals.imageOfNumber9(frame: frame)
        default:
            image = Numerals.imageOfNumber0(frame: frame)
        }
        
        return image
        
    }
    
}
