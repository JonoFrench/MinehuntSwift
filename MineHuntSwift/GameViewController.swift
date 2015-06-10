//
//  GameViewController.swift
//  MineHuntSwift
//
//  Created by Jonathan French on 28/05/2015.
//  Copyright (c) 2015 Jonathan French. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    
    @IBOutlet var skView: SKView!
    var gameType: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "homeButtonNotification", name: "menuReturn", object: nil)
        var scene : GameScene = GameScene(size: skView.bounds.size)

        scene.gameType = self.gameType!;
        skView.showsFPS = true;
        skView.showsNodeCount = true;
        skView.ignoresSiblingOrder = false;
        scene.size = skView.bounds.size
        scene.scaleMode = SKSceneScaleMode.AspectFill
        scene.gameType = gameType!
        skView.presentScene(scene)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    required init(coder aDecoder: NSCoder) {
        // Create and configure the scene.
        
        
        super.init(coder: aDecoder)

    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    
    func homeButtonNotification(){

    self.navigationController?.popViewControllerAnimated(true)
    }
    
}
