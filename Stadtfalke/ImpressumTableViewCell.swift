//
//  ImpressumTableViewCell.swift
//  Stadtfalke
//
//  Created by Manoj Singh on 29/06/18.
//  Copyright © 2018 Manoj Kumar Singh. All rights reserved.
//

import UIKit

class ImpressumTableViewCell: UITableViewCell {

    @IBOutlet weak var impressumTitleLabel: UILabel!
    @IBOutlet weak var headingTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var secondDescriptionLabel: UILabel!
    @IBOutlet weak var durchLabel: UILabel!
    @IBOutlet weak var durchDescriptionLabel: UILabel!
    @IBOutlet weak var kontaktLabel: UILabel!
    @IBOutlet weak var telefonLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
