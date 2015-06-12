//
//  menuViewController.swift
//  MineHuntSwift
//
//  Created by Jonathan French on 26/05/2015.
//  Copyright (c) 2015 Jonathan French. All rights reserved.
//

import UIKit
import CoreGraphics


class menuViewController: UIViewController,UIScrollViewDelegate {

    @IBOutlet weak var menuScroll: UIScrollView!
    @IBOutlet weak var playButton: UIButton!
    var gameType :Int = 0

    required init(coder aDecoder: NSCoder) {
       
       super.init(coder: aDecoder)

    }
    
    @IBAction func actPlay(sender: AnyObject) {
        var p: GameViewController

        let sb : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        p = sb.instantiateViewControllerWithIdentifier("gameViewController") as! GameViewController

        p.gameType = self.gameType;
        self.navigationController?.pushViewController(p, animated: true)
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBarHidden = true;
        menuScroll.delegate = self
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        
        let bundle = NSBundle(forClass: menuScrollView.self)
        for i in 0...2 {
            var frame: CGRect = CGRectZero
            frame.origin.x = menuScroll.frame.size.width * CGFloat(i)
            frame.origin.y = 0
            frame.size = menuScroll.frame.size
            var subview = bundle.loadNibNamed("menuScrollView", owner: nil, options: nil)[0] as! menuScrollView
            subview.gameType = i
            subview.setup()
            
            switch i{
            case 0:
                subview.lblPage.text = "Easy: 8*8 10 Bombs"
            case 1:
                subview.lblPage.text = "Medium: 10*10 12 Bombs"
            case 2:
                subview.lblPage.text = "Hard: 16*16 20 Bombs"
            default:
                subview.lblPage.text = "Oops"

            }
        
            subview.frame = frame
            subview.layoutIfNeeded()
            menuScroll.addSubview(subview)
        }
        menuScroll.contentSize = CGSizeMake(menuScroll.frame.size.width * 3, menuScroll.frame.size.height);
        menuScroll.layoutIfNeeded()
        menuScroll.pagingEnabled = true
        menuScroll.userInteractionEnabled = true
        menuScroll.decelerationRate = UIScrollViewDecelerationRateNormal
        menuScroll.scrollEnabled = true
        menuScroll.bounces = true        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // no vertical scrolling please
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
//        scrollView.setContentOffset(CGPointMake(scrollView.contentOffset.x,0), animated: false)
    }
    
    //get the game number of the page
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let frame: CGRect  = UIScreen.mainScreen().bounds
        let roundedValue : CGFloat = round(scrollView.contentOffset.x / frame.size.width);
        self.gameType = Int(roundedValue)
    }

}
