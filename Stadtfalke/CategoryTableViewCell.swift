//
//  CategoryTableViewCell.swift
//  Stadtfalke
//
//  Created by Manoj Kumar Singh on 17/06/18.
//  Copyright © 2018 Manoj Kumar Singh. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    var isFromLocations = Bool()
    var listOfWeek = [Dictionary<String,Any>]()

    let daysArray = ["Montag","Dienstag","Mittwoch","Donnerstag","Freitag","Samstag","Sonntag"]
    let categoriesArray = ["Alle","Frühstück","Mittagessen","Kaffee & Kuchen","Getränkespecials","Abendessen","Aktivitäten","Veranstaltungen"]
    var categoriesSelected = [true,false,false,false,false,false,false,false]

    var daysSelected = [true,false,false,false,false,false,false]
    var selectedIndex = 0
    var previousSelected = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryCollectionView.layer.borderWidth = 1
        categoryCollectionView.layer.borderColor = UIColor.init(red: 255.0/255.0, green: 194.0/255.0, blue: 0/255.0, alpha: 1).cgColor

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func daySelected(_ sender : UIButton) {
        if !sender.isSelected {
            daysSelected[sender.tag] = true
            daysSelected[previousSelected] = false
            
            categoryCollectionView.reloadItems(at: [IndexPath.init(row: sender.tag, section: 0)])
            categoryCollectionView.reloadItems(at: [IndexPath.init(row: previousSelected, section: 0)])
            previousSelected = sender.tag
        }
    }
    
    @objc func categoriesSelected(_ sender : UIButton) {
        if !sender.isSelected {
            categoriesSelected[sender.tag] = true
            categoriesSelected[previousSelected] = false
            
            categoryCollectionView.reloadItems(at: [IndexPath.init(row: sender.tag, section: 0)])
            categoryCollectionView.reloadItems(at: [IndexPath.init(row: previousSelected, section: 0)])
            previousSelected = sender.tag
        }
    }


}

extension CategoryTableViewCell : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if isFromLocations {
//            return categoriesArray.count
//        }
        return listOfWeek.count
    
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        UserDefaults.standard.set(indexPath.row, forKey: "selectedIndex")
        UserDefaults.standard.synchronize()
        
       // categoryCollectionView.reloadItems(at: [IndexPath.init(row: indexPath.row, section: 0)])
        collectionView.reloadData()
        let dict : Dictionary<String, Any> = listOfWeek[indexPath.row]
        if isFromLocations{
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getdata"), object: nil, userInfo: ["id":dict.validatedValue("id", expected: "" as AnyObject ) as! String])
        }else{
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getdata1"), object: nil, userInfo: ["id": dict.validatedValue("id", expected: "" as AnyObject ) as! String])
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCellID", for: indexPath) as! CategoryCollectionViewCell
        let dict : Dictionary<String, Any> = listOfWeek[indexPath.row]
        cell.categoryButton.setTitle(dict["name"] as! String, for: .normal)
        let index = UserDefaults.standard.value(forKey: "selectedIndex") as! Int
        if index == indexPath.item{
            cell.categoryButton.backgroundColor = UIColor.init(red: 255/255.0, green: 194/255.0, blue: 0/255.0, alpha: 1)
            
            cell.categoryButton.setTitleColor(UIColor.white, for: .normal)
        }else{
            cell.categoryButton.backgroundColor =  UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.1)
            cell.categoryButton.setTitleColor(UIColor.black, for: .normal)
        }
//        cell.categoryButton.isSelected = isFromLocations ? categoriesSelected[indexPath.row] : daysSelected[indexPath.row]
//        cell.categoryButton.backgroundColor = cell.categoryButton.isSelected ? UIColor.init(red: 255/255.0, green: 194/255.0, blue: 0/255.0, alpha: 1) : UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.1)
        cell.categoryButton.tag = indexPath.row
        cell.categoryButton.isUserInteractionEnabled = false
//        if isFromLocations {
//            cell.categoryButton.addTarget(self, action: #selector(categoriesSelected(_:)), for: .touchUpInside)
//        }else {
//            cell.categoryButton.addTarget(self, action: #selector(daySelected(_:)), for: .touchUpInside)
//        }
        return cell
        
    }
    
}
