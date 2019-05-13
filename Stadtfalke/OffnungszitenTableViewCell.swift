//
//  OffnungszitenTableViewCell.swift
//  Stadtfalke
//
//  Created by Manoj Kumar Singh on 19/06/18.
//  Copyright © 2018 Manoj Kumar Singh. All rights reserved.
//

import UIKit

class OffnungszitenTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var day1Label: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var onOffImageView: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!

    @IBOutlet weak var logoIconImageView: UIImageView!

    @IBOutlet weak var defitionLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var locationBtn: UIButton!
    @IBOutlet weak var detailBtn: UIButton!

    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!

    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
