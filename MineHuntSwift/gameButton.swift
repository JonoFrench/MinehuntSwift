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
    
    var actionTouchUpInside : Selector? = ""
    var actionTouchDown : Selector? = ""
    var actionTouchUp : Selector? = ""
   
    var targetTouchUpInside : AnyObject? = ""
    var targetTouchDown : AnyObject? = ""
    var targetTouchUp : AnyObject? = ""
    
    var isEnabled : Bool  = false
    var isSelected : Bool = false
    
//    var title : SKLabelNode = SKLabelNode()
//    var normalTexture : SKTexture
    var selectedTexture : SKTexture?
//    var disabledTexture : SKTexture
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        //var col = UIColor.redColor()
        //var s:CGSize = CGSize(width: 46,height: 46)
        super.init(texture: texture, color: color, size: size)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    func initWithTextureNormal (normal :SKTexture, selected : SKTexture)->AnyObject{
        
        normalTexture = normal
        selectedTexture = selected
        isEnabled = true
        isSelected = false
        
        let title : SKLabelNode = SKLabelNode(fontNamed: "Arial")
        title.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        title.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        self.addChild(title)
            self.userInteractionEnabled = true
        return self
    }

    func initWithTextureNormal (normal :SKTexture, selected : SKTexture, disabled : SKTexture)->AnyObject{
        return self
        
    }

    func setTouchUpInsideTarget(target : AnyObject, action: Selector){
        targetTouchUpInside = target
        actionTouchUpInside = action
    }

    func setTouchDownTarget(target : AnyObject, action: Selector){
        targetTouchDown = target
        actionTouchDown = action
    }
    
    func setTouchUpTarget(target : AnyObject, action: Selector){
        targetTouchUp = target
        actionTouchUp = action
    }
    
    func setEnabled(enabled : Bool){
        isEnabled = enabled
        
        
    }
    
    //called when the user taps the button
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("touches began")
        if isEnabled{
            if (actionTouchDown != nil){
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    NSThread.detachNewThreadSelector(self.actionTouchDown!, toTarget: self.parent!, withObject: self.targetTouchDown)
                })
            }
        }
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {

    }
    
    //called when the user finishes touching the button
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        println("touches ended")
        for touch : AnyObject in touches {
            let touchPoint : CGPoint = touch.locationInNode(self.parent!)
            
        
        
        if isEnabled && CGRectContainsPoint(self.frame,touchPoint){
            if (actionTouchUpInside != nil) {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    NSThread.detachNewThreadSelector(self.actionTouchUpInside!, toTarget: self.parent!, withObject: self.targetTouchUpInside)
                })
                
            }
        }
        isSelected = false
        if (actionTouchUp != nil) {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                NSThread.detachNewThreadSelector(self.actionTouchUp!, toTarget: self.parent!, withObject: self.targetTouchUp)
            })
        }
            
        }
    }
    
    
    
}