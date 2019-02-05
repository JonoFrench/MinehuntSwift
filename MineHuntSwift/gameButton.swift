//
//  gameButton.swift
//  MineHuntSwift
//
//  Created by Jonathan French on 03/06/2015.
//  Copyright (c) 2015 Jonathan French. All rights reserved.
//

import Foundation
import SpriteKit

class gameButton :SKSpriteNode  {
    
    var actionTouchUpInside : Selector? = #selector(self)
    var actionTouchDown : Selector? = #selector(self)
    var actionTouchUp : Selector? = #selector(self)
    
    var targetTouchUpInside : AnyObject? = "" as AnyObject?
    var targetTouchDown : AnyObject? = "" as AnyObject?
    var targetTouchUp : AnyObject? = "" as AnyObject?
    
    var isEnabled : Bool  = true
    var isSelected : Bool = false
    
    var selectedTexture : SKTexture?
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        isEnabled = true
        isSelected = false
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        isEnabled = true
        isSelected = false
    }
    
    func initWithTextureNormal (_ normal :SKTexture, selected : SKTexture)->AnyObject{
        
        normalTexture = normal
        selectedTexture = selected
        isEnabled = true
        isSelected = false
        
        let title : SKLabelNode = SKLabelNode(fontNamed: "Arial")
        title.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        title.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        self.addChild(title)
        self.isUserInteractionEnabled = true
        return self
    }
    
    func initWithTextureNormal (_ normal :SKTexture, selected : SKTexture, disabled : SKTexture)->AnyObject{
        return self
        
    }
    
    func setTouchUpInsideTarget(_ target : AnyObject, action: Selector){
        targetTouchUpInside = target
        actionTouchUpInside = action
    }
    
    func setTouchDownTarget(_ target : AnyObject, action: Selector){
        targetTouchDown = target
        actionTouchDown = action
    }
    
    func setTouchUpTarget(_ target : AnyObject, action: Selector){
        targetTouchUp = target
        actionTouchUp = action
    }
    
    func setEnabled(_ enabled : Bool){
        isEnabled = enabled
    }
    
    //called when the user taps the button
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touches began")
        guard isEnabled else {
            return
        }
        DispatchQueue.main.async(execute: { () -> Void in
            Thread.detachNewThreadSelector(self.actionTouchDown!, toTarget: self.parent!, with: self.targetTouchDown)})
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isEnabled else {
            return
        }
        for touch : AnyObject in touches {
            let touchPoint : CGPoint = touch.location(in: self.parent!)
            
            
            
            if self.frame.contains(touchPoint){
                DispatchQueue.main.async(execute: { () -> Void in
                    Thread.detachNewThreadSelector(self.actionTouchUpInside!, toTarget: self.parent!, with: self.targetTouchUpInside)
                })
            }
            isSelected = false
//            DispatchQueue.main.async(execute: { () -> Void in
//                Thread.detachNewThreadSelector(self.actionTouchUp!, toTarget: self.parent!, with: self.targetTouchUp)
//            })
        }
    }
    
    
    
}
