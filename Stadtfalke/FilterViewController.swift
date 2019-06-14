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
    var isLocationFilter = Bool()
    var categoryName = "ALLE"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getCategory()
        
    }
    
    @IBAction func filterbtnACTION(_ sender: UIButton) {
        
        
        
        Singleton.instance.refresh = true
        Singleton.instance.reloadCheck = true
        Singleton.instance.filterSelectedValues.removeAll()
        Singleton.instance.location_open_hours = "0"
        Singleton.instance.distanceFilter = ""
        Singleton.instance.category_id = ""
        Singleton.instance.reloadIndex = 0
        categoryName = "ALLE"
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK:- IBAction methods
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        Singleton.instance.reloadCheck = true
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        Singleton.instance.categoryflag = true
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
                    
                    print(otherFilterValue[section][index]["name"].stringValue)
                    
                    self.categoryName = otherFilterValue[section][index]["name"].stringValue
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
        
        Singleton.instance.filterSelectedValues = self.otherFilterValue
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
                print(self.categoryName)
                var tempArray = [JSON]()
                for element in responseJSON["data"].arrayValue {
                    
                    if element["name"].stringValue == self.categoryName {
                        Singleton.instance.category_id = element["id"].stringValue
                        let tempDict = [ "name" : element["name"].stringValue,
                                         "isSelected" : true,
                                         "id": element["id"].stringValue
                            ] as [String : Any]
                        
                        tempArray.append(JSON(tempDict))
                        
                    } else {
                        
                        let tempDict = [ "name" : element["name"].stringValue,
                                         "isSelected" : false,
                                         "id": element["id"].stringValue
                            ] as [String : Any]
                        
                        tempArray.append(JSON(tempDict))
                    }
                }
                
                
                if self.isLocationFilter {
                    
                    if self.categoryName == "ALLE" {
                        let dict = [
                            "status" : "",
                            "updated_at" : "",
                            "id" : "",
                            "name" : "Alle",
                            "created_at" : "",
                            "isSelected" : true,
                            
                            ] as [String : Any]
                        
                        let all = JSON(dict)
                        tempArray.insert(all, at: 0)
                    } else {
                        let dict = [
                            "status" : "",
                            "updated_at" : "",
                            "id" : "",
                            "name" : "Alle",
                            "created_at" : "",
                            "isSelected" : false,
                            
                            ] as [String : Any]
                        
                        let all = JSON(dict)
                        tempArray.insert(all, at: 0)
                    }
                } else {
                    if self.categoryName == "ALLE" {
                        let dict = [
                            "status" : "",
                            "updated_at" : "",
                            "id" : "",
                            "name" : "Alle",
                            "created_at" : "",
                            "isSelected" : true,
                            
                            ] as [String : Any]
                        
                        let all = JSON(dict)
                        tempArray.insert(all, at: 0)
                    } else {
                        let dict = [
                            "status" : "",
                            "updated_at" : "",
                            "id" : "",
                            "name" : "Alle",
                            "created_at" : "",
                            "isSelected" : false,
                            
                            ] as [String : Any]
                        
                        let all = JSON(dict)
                        tempArray.insert(all, at: 0)
                    }
                }
                
                self.otherFilterValue.append(self.distanceFilter)
                self.otherFilterValue.append(tempArray)
                self.otherFilterValue.append(self.categoryFilter)
                
                
                for (index, element) in Singleton.instance.filterSelectedValues.enumerated() {
                    
                    for (innerIndex, innerElement) in element.enumerated() {
                        if innerElement["isSelected"] == true {
                            let name = innerElement["name"].stringValue
                            
                            print(name)
                            for (otherIndex,element) in self.otherFilterValue[index].enumerated() {
                                if element["name"].stringValue == name {
                                    self.otherFilterValue[index][otherIndex]["isSelected"] = true
                                    
                                    if index == 0 {
                                        Singleton.instance.distanceFilter =  self.otherFilterValue[index][otherIndex]["id"].stringValue
                                    }
                                    
                                    if index == 1 {
                                        Singleton.instance.category_id =  self.otherFilterValue[index][otherIndex]["id"].stringValue
                                    }
                                    
                                    if index == 2 {
                                        Singleton.instance.location_open_hours = self.otherFilterValue[index][otherIndex]["id"].stringValue
                                    }
                                } else {
                                    self.otherFilterValue[index][otherIndex]["isSelected"] = false
                                }
                            }
                        }
                    }
                }
                
                
                print("Other Value Indexes",self.otherFilterValue)
                
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

