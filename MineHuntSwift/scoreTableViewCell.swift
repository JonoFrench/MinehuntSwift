//
//  scoreTableViewCell.swift
//  MineHuntSwift
//
//  Created by Jonathan French on 29/05/2015.
//  Copyright (c) 2015 Jonathan French. All rights reserved.
//

import UIKit

class scoreTableViewCell: UITableViewCell {

    @IBOutlet weak var lblRank: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
