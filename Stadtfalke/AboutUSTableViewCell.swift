//
//  AboutUSTableViewCell.swift
//  Stadtfalke
//
//  Created by Manoj Kumar Singh on 30/06/18.
//  Copyright © 2018 Manoj Kumar Singh. All rights reserved.
//

import UIKit
import GoogleMaps

class AboutUSTableViewCell: UITableViewCell {
    @IBOutlet weak var facebookBtn: UIButton!
    @IBOutlet weak var instagramBtn: UIButton!
    @IBOutlet weak var gmailBtn: UIButton!

    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var firstLabel: UILabel!
    
    @IBOutlet weak var descriptionlabel: UILabel!
    @IBOutlet weak var uberUnslabel: UILabel!
    @IBOutlet weak var telephoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var fourthLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var myMapView: GMSMapView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
