//
//  LabelTableViewCell.swift
//  Stadtfalke
//
//  Created by Ashish Kr Singh on 02/11/18.
//  Copyright © 2018 Manoj Kumar Singh. All rights reserved.
//

import UIKit

class LabelTableViewCell: UITableViewCell {

    @IBOutlet weak var textViewText: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
