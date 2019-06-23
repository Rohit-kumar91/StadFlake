//
//  MenuTableViewCell.swift
//  Stadtfalke
//
//  Created by Rohit Prajapati on 25/05/19.
//  Copyright © 2019 Manoj Kumar Singh. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var downloadSpinner: UIActivityIndicatorView!
    @IBOutlet weak var progress: UIProgressView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
