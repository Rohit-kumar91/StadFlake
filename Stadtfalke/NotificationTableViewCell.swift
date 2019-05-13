//
//  NotificationTableViewCell.swift
//  Stadtfalke
//
//  Created by Rohit Kumar on 06/05/19.
//  Copyright © 2019 Manoj Kumar Singh. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imageNotification: UIImageView!
    @IBOutlet weak var notificationTittle: UILabel!
    @IBOutlet weak var notificationby: UILabel!
    @IBOutlet weak var notiifcationTime: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
