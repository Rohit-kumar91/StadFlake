//
//  SpecialViewController.swift
//  Stadtfalke
//
//  Created by Manoj Kumar Singh on 17/06/18.
//  Copyright © 2018 Manoj Kumar Singh. All rights reserved.
//

import UIKit
import SwiftyJSON

class SpecialViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var topConstant: NSLayoutConstraint!
    //@IBOutlet weak var conatinerView1: UIView!
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var specialTableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var postArray = [PageOfferInfo]()
    var list = [Dictionary<String,AnyObject>]()
    var selectedIndex = "0"
    let refreshControl = UIRefreshControl()
    var selectedRow = 0
    var daysArray = [JSON]()
    var tempDays = [JSON]()
    var specialsData = [JSON]()
    var tempSpecialData = [JSON]()
    var specialResponseData = JSON()
    var search:String=""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let locationsDetailsVC = mainStoryboard.instantiateViewController(withIdentifier: "LocationDetailsViewControllerID") as! LocationDetailsViewController
      
        self.navigationController?.pushViewController(locationsDetailsVC, animated: true)
       
        UserDefaults.standard.set(0, forKey: "selectedIndex")
        UserDefaults.standard.synchronize()
        let today = Date()
        let tomorrow = Calendar.current.date(byAdding: .day, value: 6, to: today)
        self.descriptionLabel.text = "Diese Übersicht zeigt dir die Specials vom\n \(today.dateStringFromDate("dd.MM.yyyy")) - \(tomorrow?.dateStringFromDate("dd.MM.yyyy") ?? "")"
        
        initialMethod()
        tempDays =  JSON(Singleton.instance.daysArray).arrayValue
        daysArray = calculateDaysArray(daysArray: tempDays)
        myCollectionView.reloadData()
        Singleton.instance.id = daysArray[0]["id"].stringValue
        
        getSpecials(Singleton.instance.id,
                    location_open_hours: Singleton.instance.location_open_hours,
                    distanceFilter: Singleton.instance.distanceFilter,
                    category_id: Singleton.instance.category_id)

        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshSpecials(notfication:)), name: NSNotification.Name(rawValue: "refreshNotificationData"), object: nil)
        
        self.specialTableView.rowHeight = UITableViewAutomaticDimension
        self.specialTableView.estimatedRowHeight = 200
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(sender:)), for: .valueChanged)
        specialTableView.addSubview(refreshControl)
        
        if Singleton.instance.location_Id != "" {
            menuButton.setImage(#imageLiteral(resourceName: "backWhite"), for: .normal)
            menuButton.tag = 1
        } else {
            menuButton.setImage(#imageLiteral(resourceName: "menu"), for: .normal)
            menuButton.tag = 2
        }
        
        
        if kWindowHeight <= 568 {
            topConstant.constant = 20
        }else{
            topConstant.constant = 1
        }
    }
    
    
    

    func calculateDaysArray(daysArray: [JSON]) -> [JSON] {
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayInWeek = dateFormatter.string(from: date)
        var indexOfday = Int()
        for (index,element) in daysArray.enumerated() {
            if element["day"].stringValue == dayInWeek {
                indexOfday = index
                break
            }
        }
        
        var postDaysArray = [JSON]()
        var preDaysArray = [JSON]()
        for index in indexOfday..<daysArray.count {
            postDaysArray.append(daysArray[index])
        }
        
        for index in 0..<indexOfday {
            preDaysArray.append(daysArray[index])
        }
        
        
        print("finals days arrray",postDaysArray + preDaysArray)
        return postDaysArray + preDaysArray
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if   Singleton.instance.reloadCheck  {
            
            Singleton.instance.reloadCheck = false
            getSpecials(Singleton.instance.id,
                        location_open_hours: Singleton.instance.location_open_hours,
                        distanceFilter: Singleton.instance.distanceFilter,
                        category_id: Singleton.instance.category_id)
        }
        
    }
    
    @objc func refresh(sender:AnyObject) {
        
        getSpecials(Singleton.instance.id,
                    location_open_hours: Singleton.instance.location_open_hours,
                    distanceFilter: Singleton.instance.distanceFilter,
                    category_id: Singleton.instance.category_id)
        refreshControl.endRefreshing()
        
    }
    
    
    
    @objc func refreshSpecials(notfication: NSNotification) {
        
        getSpecials(Singleton.instance.id,
                    location_open_hours: Singleton.instance.location_open_hours,
                    distanceFilter: Singleton.instance.distanceFilter,
                    category_id: Singleton.instance.category_id)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- Helper methods
    func initialMethod() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK:- IBAction methods
    @IBAction func menuButtonAction(_ sender: UIButton) {
        if sender.tag == 1 {
            menuButton.setImage(#imageLiteral(resourceName: "menu"), for: .normal)
            Singleton.instance.location_Id = ""
            getSpecials(Singleton.instance.id,
                        location_open_hours: Singleton.instance.location_open_hours,
                        distanceFilter: Singleton.instance.distanceFilter,
                        category_id: Singleton.instance.category_id)
        } else {
            self.view.endEditing(true)
            self.toggleSlider()
        }
        
       
    }
    
    @IBAction func notificationButtonAction(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        self.present(vc, animated: true, completion: nil)
        
    }

    @IBAction func filterButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let filterVC = self.storyboard?.instantiateViewController(withIdentifier: "FilterViewControllerID") as! FilterViewController
        self.present(filterVC, animated: true, completion: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return daysArray.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        selectedRow = indexPath.row
        myCollectionView.reloadData()
        
        getSpecials(daysArray[indexPath.row]["id"].stringValue,
                    location_open_hours: Singleton.instance.location_open_hours,
                    distanceFilter: Singleton.instance.distanceFilter,
                    category_id: Singleton.instance.category_id)
        }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCellID", for: indexPath) as! CategoryCollectionViewCell
    
        
        cell.categoryButton.setTitle(daysArray[indexPath.row]["dayName"].stringValue, for: .normal)
        
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
    
    
    
    func getSpecials(_ weekDayId: String, location_open_hours: String, distanceFilter : String, category_id: String) {
        
        let lat = UserDefaults.standard.value(forKey: "lat") as! Double
        let long = UserDefaults.standard.value(forKey: "long") as! Double
        
        let param = [
            "city_slug" : Singleton.instance.citySlug,
            "current_latitude": lat,
            "current_longitude" : long,
            "location_id" : Singleton.instance.location_Id,
            "weekday_id" : weekDayId,
            "location_open_hours" : location_open_hours,
            "distanceFilter": distanceFilter,
            "category_id" : category_id
        
            ] as [String : Any]
        
        
        print(param)
        Singleton.instance.location_open_hours = "0"
        Singleton.instance.distanceFilter = ""
        Singleton.instance.category_id = ""
        
        ServiceHelper.sharedInstance.createPostRequest(isShowHud: true, params: param as [String : AnyObject], apiName: "api/specials") { (response, error) in
            
            if error != nil {
                MCCustomAlertController.alert(title: "", message: (error?.localizedDescription)!, buttons: ["OK"], tapBlock: { (action, index) in
                    //
                    
                })
                return
            }
            
            if (response != nil) {
                
                
                
                self.specialsData.removeAll()
                let JSONResponse = JSON(response as Any)
                self.specialResponseData = JSONResponse
                self.specialsData = JSONResponse["data"].arrayValue
                self.tempSpecialData = self.specialsData
                
                DispatchQueue.main.async {
                    self.specialTableView.reloadData()
                }
               
                
            } else {
                MCCustomAlertController.alert(title: "", message: "Something went wrong.", buttons: ["OK"], tapBlock: { (action, index) in
                    //
                })
                return
            }
        }
    }
    
    

}

extension SpecialViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCellID") as! CategoryTableViewCell
//        cell.isFromLocations = false
//        cell.listOfWeek = self.listOfWeek
//        return cell
//    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let locationsDetailsVC = mainStoryboard.instantiateViewController(withIdentifier: "ProgramDetailViewController") as! ProgramDetailViewController
        locationsDetailsVC.specialDetails = specialsData[indexPath.row]
        let sideMenuController = APPDELEGATE.sideMenuController
        guard let centeralNavController = sideMenuController.centerViewController as? UINavigationController else {
            return
        }
        
        centeralNavController.popToRootViewController(animated: false)
        centeralNavController.setViewControllers([locationsDetailsVC], animated: false)
        sideMenuController.closeSlider(.left, animated: true) { (_) in
            //do nothing
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return specialsData.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCellID") as! PostTableViewCell
        
       
        
       // cell.iconImageView
        cell.postTitleLabel.text = specialsData[indexPath.row]["name"].stringValue
        
        cell.postSubTitleLabel.text = "@\(specialsData[indexPath.row]["location_info"]["name"].stringValue)"
        
        
        if specialsData[indexPath.row]["location_info"]["distance"].stringValue == "" {
            cell.distanceLabel.text = "0.0" + "KM"
        } else {
            cell.distanceLabel.text =   String(format: "%.2f", specialsData[indexPath.row]["location_info"]["distance"].doubleValue) + " KM"
        }
        
        
        
        let imageUrl = "http://83.137.194.211/stadtfalke" + specialsData[indexPath.row]["logo_media_image"]["path"].stringValue + "/" +
            specialsData[indexPath.row]["logo_media_image"]["name"].stringValue
        
        
        cell.postImageView.sd_setImage(with: URL.init(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "Placeholder"), options: .continueInBackground, completed: nil)
        
        
        let logoImage = "http://83.137.194.211/stadtfalke" + specialsData[indexPath.row]["location_info"]["logo_media_image"]["path"].stringValue + "/" +
            specialsData[indexPath.row]["location_info"]["logo_media_image"]["name"].stringValue
        
        
        cell.iconImageView.sd_setImage(with: URL.init(string: logoImage), placeholderImage: #imageLiteral(resourceName: "Placeholder"), options: .continueInBackground, completed: nil)
       
        
        if specialsData[indexPath.row]["location_opening_hours"].stringValue == "geöffnet" {
            cell.onOffLabel.backgroundColor = UIColor.green
        }else{
            cell.onOffLabel.backgroundColor = UIColor.red
        }
        return cell
        
    }
    
    
}

extension SpecialViewController : UITextFieldDelegate {
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
            
            
            print("Response Data", specialResponseData)
            print("=============================\n==========================")
            print("Reponse Array Data", specialResponseData["data"].arrayObject as Any)
            
            let data = specialResponseData["data"].arrayObject as Any
            var filterData = JSON()
            
            let searchPredicate = NSPredicate(format: "name contains[cd] %@", searchText)
            if let array = data as? [[String:AnyObject]] {
                filterData = JSON(array.filter{ searchPredicate.evaluate(with: $0) })
                print(filterData)
            }
            
            specialsData.removeAll()
            if filterData.arrayValue.count != 0 {
                specialsData = filterData.arrayValue
            } else if searchText == "" {
                specialsData = tempSpecialData
            } else {
                specialsData = []
            }
//
         specialTableView.reloadData()
            
            
        }
        
        return true
        }
    
}
    
    

