//
//  FAQTableViewCell.swift
//  Stadtfalke
//
//  Created by Manoj Kumar Singh on 15/06/18.
//  Copyright © 2018 Manoj Kumar Singh. All rights reserved.
//

import UIKit

class FAQTableViewCell: UITableViewCell {
    @IBOutlet weak var quesAnsLabel: UILabel!
    @IBOutlet weak var sepratorView: UIView!
    @IBOutlet weak var answerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
