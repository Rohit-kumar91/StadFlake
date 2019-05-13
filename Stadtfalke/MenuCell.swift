//
//  MenuCell.swift
//  Stadtfalke
//
//  Created by Rohit Prajapati on 27/04/19.
//  Copyright © 2019 Manoj Kumar Singh. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
