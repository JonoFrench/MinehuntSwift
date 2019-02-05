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
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.homeButtonNotification), name: NSNotification.Name(rawValue: "menuReturn"), object: nil)
        let scene : GameScene = GameScene(size: skView.bounds.size)
        scene.gameType = self.gameType!
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = false
        scene.size = skView.bounds.size
        scene.scaleMode = SKSceneScaleMode.aspectFill
        scene.gameType = gameType!
        skView.presentScene(scene)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    required init?(coder aDecoder: NSCoder) {
        // Create and configure the scene.
        super.init(coder: aDecoder)
    }

    // Hide the status bar
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    func homeButtonNotification(){
        DispatchQueue.main.async(execute: {
            self.navigationController?.popViewController(animated: true)
        })
        
    }
    
}
