//
//  FilterViewController.swift
//  Stadtfalke
//
//  Created by Manoj Kumar Singh on 17/06/18.
//  Copyright © 2018 Manoj Kumar Singh. All rights reserved.
//

import UIKit
import SwiftyJSON

class FilterViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var filterTableView: UITableView!
    
    let sectionTitleArray = ["   Distanz auswählen","   Kategorie auswählen","   Kategorie auswählen"]
    let distanceFilter = JSON([["name" : "aufsteigend", "isSelected" : false, "id": 1],["name" : "absteigend", "isSelected" : false, "id": 2]]).arrayValue
    let categoryFilter = JSON([["name" : "alle", "isSelected" : true, "id": 0], ["name" : "geöffnet", "isSelected" : false, "id": 1]]).arrayValue
    var otherFilterValue  = [[JSON]]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getCategory()
        
    }
    
    @IBAction func filterbtnACTION(_ sender: UIButton) {
        Singleton.instance.reloadCheck = true
        self.dismiss(animated: true, completion: nil)
    }

    // MARK:- IBAction methods
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        Singleton.instance.reloadCheck = false
        Singleton.instance.location_open_hours = ""
        Singleton.instance.distanceFilter = ""
        Singleton.instance.category_id = ""
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
      self.dismiss(animated: true, completion: nil)
    }
   
    @IBAction func radioButton(_ sender: UIButton) {
        
        let section = (sender.tag)/1000;
        let row = (sender.tag)%1000;
        
        
        if section == 0 {
            if row == 0 {
                self.otherFilterValue[section][0]["isSelected"] = true
                self.otherFilterValue[section][1]["isSelected"] = false
                 Singleton.instance.distanceFilter =  self.otherFilterValue[section][row]["id"].stringValue
            } else {
                self.otherFilterValue[section][0]["isSelected"] = false
                self.otherFilterValue[section][1]["isSelected"] = true
                Singleton.instance.distanceFilter =  self.otherFilterValue[section][row]["id"].stringValue
            }
            
        } else if section == 1 {
            
            for (index, _) in self.otherFilterValue[section].enumerated() {
                if index == row {
                    Singleton.instance.reloadIndex = index
                    otherFilterValue[section][index]["isSelected"] = true
                    Singleton.instance.category_id =  self.otherFilterValue[section][index]["id"].stringValue
                } else {
                    self.otherFilterValue[section][index]["isSelected"] = false
                }
            }
            
            print(self.otherFilterValue[section])
            
        } else if section == 2 {
            if row == 0 {
                self.otherFilterValue[section][0]["isSelected"] = true
                self.otherFilterValue[section][1]["isSelected"] = false
                Singleton.instance.location_open_hours =  self.otherFilterValue[section][row]["id"].stringValue
            } else {
                self.otherFilterValue[section][0]["isSelected"] = false
                self.otherFilterValue[section][1]["isSelected"] = true
                Singleton.instance.location_open_hours =  self.otherFilterValue[section][row]["id"].stringValue
            }
        }
        
        filterTableView.reloadData()
    }
    
    func getCategory() {
        ServiceHelper.sharedInstance.createGetRequest(isShowHud: true, params: [:], apiName: "api/categories") { (response, error) in
            
            if error != nil {
                MCCustomAlertController.alert(title: "", message: (error?.localizedDescription)!, buttons: ["OK"], tapBlock: { (action, index) in
                })
                return
            }
            
            
            if (response != nil) {
                
                let responseJSON = JSON(response as Any)
                
                var tempArray = [JSON]()
                for element in responseJSON["data"].arrayValue {
                    let tempDict = [ "name" : element["name"].stringValue,
                                     "isSelected" : false,
                                     "id": element["id"].stringValue
                        ] as [String : Any]
                    
                    
                    tempArray.append(JSON(tempDict))
                }
                
                
                self.otherFilterValue.append(self.distanceFilter)
                self.otherFilterValue.append(tempArray)
                self.otherFilterValue.append(self.categoryFilter)
                
                print(self.otherFilterValue)
                
                self.filterTableView.dataSource = self
                self.filterTableView.reloadData()
                
            } else {
                MCCustomAlertController.alert(title: "", message: "Something went wrong.", buttons: ["OK"], tapBlock: { (action, index) in
                    //
                })
                return
            }
        }
    }
}

extension FilterViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitleArray.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitleArray[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return otherFilterValue[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SingleLabelTableViewCell
        
        print(otherFilterValue[indexPath.section][indexPath.row]["name"].stringValue)
        cell.filteTitleLabel.text = otherFilterValue[indexPath.section][indexPath.row]["name"].stringValue
        
        if otherFilterValue[indexPath.section][indexPath.row]["isSelected"].boolValue {
            cell.radioButton.setImage(#imageLiteral(resourceName: "radioCheck"), for: .normal)
        } else {
            cell.radioButton.setImage(#imageLiteral(resourceName: "radioUncheck"), for: .normal)
           
        }
        
        cell.radioButton.tag = indexPath.section * 1000 + indexPath.row;
        
        return cell
    }
}

