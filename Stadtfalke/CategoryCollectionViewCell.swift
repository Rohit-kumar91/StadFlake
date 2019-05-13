//
//  CategoryCollectionViewCell.swift
//  Stadtfalke
//
//  Created by Manoj Kumar Singh on 17/06/18.
//  Copyright © 2018 Manoj Kumar Singh. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var categoryButton: UIButton!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryButton.layer.cornerRadius = 3
        categoryButton.clipsToBounds = true
    }

}
