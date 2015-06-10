//
//  menuScrollView.swift
//  MineHuntSwift
//
//  Created by Jonathan French on 26/05/2015.
//  Copyright (c) 2015 Jonathan French. All rights reserved.
//

import UIKit

class menuScrollView: UIView,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tblScores: UITableView!
    @IBOutlet weak var lblPage: UILabel!
    var gameType : Int = 0
    var scores : Array<highScore>=[]
    
    required init(coder: NSCoder)
    {
        super.init(coder: coder)
        
        //NSBundle.mainBundle().loadNibNamed("menuScrollView", owner: self, options: nil)
    }
    
    func setup()
    {
        self.tblScores.registerNib(UINib (nibName: "scoreTableViewCell", bundle: nil), forCellReuseIdentifier: "scoreCell")
      //  self.tblScores.registerNib:[UINib nibWithNibName:@"scoreTableViewCell" bundle:nil] forCellReuseIdentifier:@"scoreCell"
        self.scores = highScores().getHighScores(self.gameType)

        
        tblScores.delegate = self
        tblScores.dataSource = self
        tblScores.reloadData()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scores.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
      
        var heightDiv = 10.0;
        if (self.tblScores.frame.size.height/10 < 40) {
            heightDiv = 5;
        }
        return self.tblScores.frame.size.height / CGFloat(heightDiv);
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let score = scores[indexPath.row]
        let cell:scoreTableViewCell = self.tblScores.dequeueReusableCellWithIdentifier("scoreCell", forIndexPath: indexPath) as! scoreTableViewCell
        
        cell.lblDate.text = score.date
        cell.lblRank.text = String( indexPath.row + 1)
        cell.lblTime.text = String (score.time) + " Secs"
        return cell
    }
    
    
}
