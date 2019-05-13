//
//  PostTableViewCell.swift
//  Stadtfalke
//
//  Created by Manoj Kumar Singh on 17/06/18.
//  Copyright © 2018 Manoj Kumar Singh. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var dotImageView: UIImageView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postSubTitleLabel: UILabel!
    @IBOutlet weak var onOffLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var switchButton: UISwitch!
    
    @IBOutlet weak var timeLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
