//
//  menuViewController.swift
//  MineHuntSwift
//
//  Created by Jonathan French on 26/05/2015.
//  Copyright (c) 2015 Jonathan French. All rights reserved.
//

import UIKit
import CoreGraphics
import GoogleMobileAds

class menuViewController: UIViewController,UIScrollViewDelegate {

    @IBOutlet weak var menuScroll: UIScrollView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var adBanner: GADBannerView!
    
    var gameType :Int = 0

    required init?(coder aDecoder: NSCoder) {
       
       super.init(coder: aDecoder)

    }
    
    @IBAction func actPlay(_ sender: AnyObject) {
        var p: GameViewController

        let sb : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        p = sb.instantiateViewController(withIdentifier: "gameViewController") as! GameViewController

        p.gameType = self.gameType;
        self.navigationController?.pushViewController(p, animated: true)
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuScroll.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true;
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        adBanner.adUnitID = "ca-app-pub-9336538600879345/8704136517"
        adBanner.rootViewController = self
        let request: GADRequest = GADRequest()
        request.testDevices = ["8a1df282f0b2b3dba789eb716c652302",kGADSimulatorID]
        adBanner.load(request)
        let bundle = Bundle(for: menuScrollView.self)
        for i in 0...2 {
            var frame: CGRect = CGRect.zero
            frame.origin.x = menuScroll.frame.size.width * CGFloat(i)
            frame.origin.y = 0
            frame.size = menuScroll.frame.size
            let subview = bundle.loadNibNamed("menuScrollView", owner: nil, options: nil)?[0] as! menuScrollView
            subview.gameType = i
            subview.setup()
            
            switch i{
            case 0:
                subview.lblPage.text = "Easy"
            case 1:
                subview.lblPage.text = "Medium"
            case 2:
                subview.lblPage.text = "Hard"
            default:
                subview.lblPage.text = "Oops"

            }
        
            subview.frame = frame
            subview.layoutIfNeeded()
            menuScroll.addSubview(subview)
        }
        menuScroll.contentSize = CGSize(width: menuScroll.frame.size.width * 3, height: menuScroll.frame.size.height);
        menuScroll.layoutIfNeeded()
        menuScroll.isPagingEnabled = true
        menuScroll.isUserInteractionEnabled = true
        menuScroll.decelerationRate = UIScrollViewDecelerationRateNormal
        menuScroll.isScrollEnabled = true
        menuScroll.bounces = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // no vertical scrolling please
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
//        scrollView.setContentOffset(CGPointMake(scrollView.contentOffset.x,0), animated: false)
    }
    
    //get the game number of the page
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let frame: CGRect  = UIScreen.main.bounds
        let roundedValue : CGFloat = round(scrollView.contentOffset.x / frame.size.width);
        self.gameType = Int(roundedValue)
    }

}
