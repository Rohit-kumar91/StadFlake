//
//  LocationsViewController.swift
//  Stadtfalke
//
//  Created by Manoj Kumar Singh on 17/06/18.
//  Copyright © 2018 Manoj Kumar Singh. All rights reserved.
//

import UIKit
import SwiftyJSON
class LocationsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var locationsTableView: UITableView!
    
    var locationsArray = [Dictionary<String,AnyObject>]()
    var listOfWeek = [Dictionary<String,Any>]()
    let refreshControl = UIRefreshControl()
    var selectedRow = 0
    var categoryMenu = [JSON]()
    var locationData = [JSON]()
    var locationResponseData = JSON()
    var tempLocationData = [JSON]()

    override func viewDidLoad() {
        super.viewDidLoad()
        initialMethod()
      
       
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if Singleton.instance.reloadCheck {
            Singleton.instance.reloadCheck = false
            selectedRow = Singleton.instance.reloadIndex + 1
            
            myCollectionView.reloadData()
            let indexPath = IndexPath(row: selectedRow, section: 0)
            myCollectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.left, animated: true)
            
            self.getLocationData(category_id:  Singleton.instance.category_id, location_opening_hours: Singleton.instance.location_open_hours, distanceFilter: Singleton.instance.distanceFilter )
            
        } else {
            getCategory()
        }
        
        
        

    }
    
    override func viewDidLayoutSubviews() {
        //setTabBarVisible(visible: false, animated: true)
        
    }
    
    @objc func refresh(sender:AnyObject) {
        // Code to refresh table view
        //self.callAPIToGetWeekDay()
        //refreshControl.endRefreshing()
    }
    
    
    func getCategory() {
        
       
        
        ServiceHelper.sharedInstance.createGetRequest(isShowHud: false, params: [:], apiName: "api/categories") { (response, error) in
            
            if error != nil {
                MCCustomAlertController.alert(title: "", message: (error?.localizedDescription)!, buttons: ["OK"], tapBlock: { (action, index) in
                })
                return
            }
            
            
            if (response != nil) {
               
                let responseJSON = JSON(response as Any)
                self.categoryMenu = responseJSON["data"].arrayValue
                
                let dict = [
                    "status" : "",
                    "updated_at" : "",
                    "id" : "",
                    "name" : "ALLE",
                    "created_at" : ""
                    
                ]
                
                let all = JSON(dict)
                self.categoryMenu.insert(all, at:0)
                
                print(self.categoryMenu)
                self.selectedRow = 0
                self.myCollectionView.reloadData()
                let indexPath = IndexPath(row: 0, section: 0)
                self.myCollectionView.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.left, animated: true)
                
                self.getLocationData(category_id: "", location_opening_hours: "", distanceFilter: "" )
                
            } else {
                MCCustomAlertController.alert(title: "", message: "Something went wrong.", buttons: ["OK"], tapBlock: { (action, index) in
                    //
                })
                return
            }
        }
    }
    
    
    
    func getLocationData(category_id : String, location_opening_hours: String, distanceFilter: String) {
        
        let lat = UserDefaults.standard.value(forKey: "lat") as! Double
        let long = UserDefaults.standard.value(forKey: "long") as! Double
        
       
        
        let dict = [
            "city_slug" : Singleton.instance.citySlug ,
            "category_id" : Singleton.instance.category_id,
            "location_opening_hours" : Singleton.instance.location_open_hours,
            "distanceFilter" : Singleton.instance.distanceFilter,
            "current_latitude" : lat,
            "current_longitude" : long
            ] as [String : Any]
        
        ServiceHelper.sharedInstance.createPostRequest(isShowHud: true, params: dict as [String : AnyObject], apiName: "api/locations") { (response, error) in
            if error != nil {
                MCCustomAlertController.alert(title: "", message: (error?.localizedDescription)!, buttons: ["OK"], tapBlock: { (action, index) in
                })
                return
            }
            
            if (response != nil) {
                
                Singleton.instance.location_open_hours = "0"
                Singleton.instance.distanceFilter = ""
                Singleton.instance.category_id = ""
                
                let responseJSON = JSON(response as Any)
                print(responseJSON)
                self.locationResponseData = responseJSON
                self.locationData = responseJSON["data"].arrayValue
                self.tempLocationData = self.locationData
                self.locationsTableView.reloadData()
                
            } else {
                MCCustomAlertController.alert(title: "", message: "Something went wrong.", buttons: ["OK"], tapBlock: { (action, index) in
                    //
                })
                return
            }
        }
    }
    
    
    // MARK:- Helper methods
    func initialMethod() {
    //    locationsArray = [["Icon":"get","Title":"Gutleut","Distance":"0.37 km"],["Icon":"lacrd","Title":"L'Arcade","Distance":"1.37 km"],["Icon":"get","Title":"Gutleut","Distance":"0.37 km"],["Icon":"lacrd","Title":"L'Arcade","Distance":"1.37 km",],["Icon":"get","Title":"Gutleut","Distance":"0.37 km"],["Icon":"lacrd","Title":"L'Arcade","Distance":"1.37 km"],["Icon":"get","Title":"Gutleut","Distance":"0.37 km"],["Icon":"lacrd","Title":"L'Arcade","Distance":"1.37 km",]]
    }
    
//    @objc func yourfunction(notfication: NSNotification) {
//        let dict = notfication.userInfo as! Dictionary<String, AnyObject>
//        locationsArray.removeAll()
//     //   callAPIToGetLocation(index: dict["id"] as! String)
//
//        locationApiHit(index: "")
//    }

    // MARK:- IBAction methods
    @IBAction func menuButtonAction(_ sender: UIButton) {
        self.toggleSlider()
        self.view.endEditing(true)
       // self.navigationController?.popViewController(animated: true)
      //  self.toggleSlider()
    }
    
    @IBAction func notificationButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let sideMenuController = APPDELEGATE.sideMenuController
        guard let centeralNavController = sideMenuController.centerViewController as? UINavigationController else {
            return
        }
        centeralNavController.popToRootViewController(animated: false)
        
        let mitteilungenVC = self.storyboard?.instantiateViewController(withIdentifier: "MitteilungenViewControllerID") as! MitteilungenViewController
        centeralNavController.setViewControllers([mitteilungenVC], animated: false)
        sideMenuController.closeSlider(.left, animated: true) { (_) in
            //do nothing
        }
    }

    
    @IBAction func filterButtonAction(_ sender: UIButton) {
        let filterVC = self.storyboard?.instantiateViewController(withIdentifier: "FilterViewControllerID") as! FilterViewController
        self.present(filterVC, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        if isFromLocations {
        //            return categoriesArray.count
        //        }
        return categoryMenu.count
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        let font : UIFont = UIFont.init(name: "Arial", size: 15.0)!
        let text = categoryMenu[indexPath.row]["name"].stringValue
        let width = UILabel.textWidth(font: font, text: text)
        return CGSize(width: width + 35, height: 40)
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        selectedRow = indexPath.row
        
        self.myCollectionView.reloadData()
        self.getLocationData(category_id:  categoryMenu[indexPath.row]["id"].stringValue, location_opening_hours: Singleton.instance.location_open_hours, distanceFilter: Singleton.instance.distanceFilter )
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCellID", for: indexPath) as! CategoryCollectionViewCell
        
        cell.categoryButton.setTitle((categoryMenu[indexPath.row]["name"].stringValue).capitalized, for: .normal)
        if selectedRow == indexPath.item{
            cell.categoryButton.backgroundColor = UIColor.init(red: 255/255.0, green: 194/255.0, blue: 0/255.0, alpha: 1)
            cell.categoryButton.setTitleColor(UIColor.white, for: .normal)
        }else{
            cell.categoryButton.backgroundColor =  UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.1)
            cell.categoryButton.setTitleColor(UIColor.black, for: .normal)
        }
        
        cell.categoryButton.tag = indexPath.row
        cell.categoryButton.isUserInteractionEnabled = false
        
        return cell
        
    }

}

extension LocationsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCellID") as! CategoryTableViewCell
//        cell.isFromLocations = true
//        cell.listOfWeek = self.listOfWeek
//        return cell
//    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationData.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCellID") as! PostTableViewCell
       
        let urlString = "http://83.137.194.211/stadtfalke" + locationData[indexPath.row]["logo_media_image"]["path"].stringValue + "/" +
            locationData[indexPath.row]["logo_media_image"]["name"].stringValue
        
        
        
        print(urlString)
        
        cell.iconImageView.sd_setImage(with: URL.init(string: urlString), placeholderImage: UIImage.init(named: "Placeholder"), options: .lowPriority, completed: nil)
        
        if locationData[indexPath.row]["distance"].stringValue == "" {
            cell.distanceLabel.text = "0.0" + "KM"
        } else {
           
            cell.distanceLabel.text =   String(format: "%.2f", locationData[indexPath.row]["distance"].doubleValue) + " KM"
        }
        
        
        cell.postTitleLabel.text = locationData[indexPath.row]["name"].stringValue
        
        
        if locationData[indexPath.row]["location_opening_hours"].stringValue == "geschlossen" {
            cell.dotImageView.backgroundColor = UIColor.red
        } else {
            cell.dotImageView.backgroundColor = UIColor.green
        }
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dict = [
            "lat" : locationData[indexPath.row]["latitude"].stringValue,
            "longi" : locationData[indexPath.row]["longitude"].stringValue,
            "id" : locationData[indexPath.row]["slug"].stringValue
            ] 
        
        
        
        print(dict)
        
        // post a notification
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "detailsLocation"), object: nil, userInfo: dict)
        
       
    }
    
    
}

extension LocationsViewController : UITextFieldDelegate {
    
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
        
        public func textFieldDidEndEditing(_ textField: UITextField){
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshOfferList1"), object: nil, userInfo: ["str": textField.text?.count == 0 ? "" : textField.text!])
            //self.callAPIToGetPageOffer(index: 1)
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            
            var searchText  = textField.text! + string
            
            if string  == "" {
                searchText = (searchText as String).substring(to: searchText.index(before: searchText.endIndex))
            }
            
            if searchText == "" {
                // isSearch = false
                // tblSearchResult.reloadData()
            }
            else{
                
                print(searchText)
                
                let data = locationResponseData["data"].arrayObject as Any
                var filterData = JSON()
                
                let searchPredicate = NSPredicate(format: "name contains[cd] %@", searchText)
                if let array = data as? [[String:AnyObject]] {
                    filterData = JSON(array.filter{ searchPredicate.evaluate(with: $0) })
                    print(filterData)
                }
                
                locationData.removeAll()
                if filterData.arrayValue.count != 0 {
                    locationData = filterData.arrayValue
                } else if searchText == "" {
                    locationData = tempLocationData
                } else {
                    locationData = []
                }
                //
                locationsTableView.reloadData()
                
                
            }
            
            return true
        }

}

