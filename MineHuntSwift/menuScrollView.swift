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
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
    }
    
    func setup()
    {
        self.tblScores.register(UINib (nibName: "scoreTableViewCell", bundle: nil), forCellReuseIdentifier: "scoreCell")
        self.scores = highScores().getHighScores(self.gameType)
        tblScores.delegate = self
        tblScores.dataSource = self
        tblScores.reloadData()
        tblScores.bounces = false
        tblScores.allowsSelection = false
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scores.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      
        var heightDiv = 10.0;
        if (self.tblScores.frame.size.height/10 < 40) {
            heightDiv = 5;
        }
        return self.tblScores.frame.size.height / CGFloat(heightDiv);
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let score = scores[indexPath.row]
        let cell:scoreTableViewCell = self.tblScores.dequeueReusableCell(withIdentifier: "scoreCell", for: indexPath) as! scoreTableViewCell
        cell.lblTime.textAlignment = .right
        if score.time != 3600 {
            let sec = score.time % 60
            let min = score.time / 60
            cell.lblTime.text = String(format: "%d:%02d",min,sec)
            cell.lblDate.text = score.date
        } else {
            cell.lblTime.text = ""
            cell.lblDate.text = ""
        }
        cell.lblRank.text = String( indexPath.row + 1)
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = .white
        } else {
            cell.backgroundColor = UIColor.yellow
        }
        return cell
    }
    
    
}
