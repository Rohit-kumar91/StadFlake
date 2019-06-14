//
//  NewScreenViewController.swift
//  Stadtfalke
//
//  Created by Ashish Kr Singh on 13/12/18.
//  Copyright © 2018 Manoj Kumar Singh. All rights reserved.
//

import UIKit

class NewScreenViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var specialTableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var postArray = [PageOfferInfo]()
    var listOfWeek = [Dictionary<String,Any>]()
    var selectedIndex = "0"
    let refreshControl = UIRefreshControl()
    var locationID = ""
    var list = [Dictionary<String,AnyObject>]()
    var selectedRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.set(0, forKey: "selectedIndex")
        UserDefaults.standard.synchronize()
        let today = Date()
        let tomorrow = Calendar.current.date(byAdding: .day, value: 6, to: today)
        self.descriptionLabel.text = "Diese Übersicht zeigt dir die Specials vom\n \(today.dateStringFromDate("dd.MM.yyyy")) bis \(tomorrow?.dateStringFromDate("dd.MM.yyyy") ?? "")"
        
        initialMethod()
        self.callAPIToGetWeekDay()
        callAPIToGetPageOffer()
        NotificationCenter.default.addObserver(self, selector: #selector(self.yourfunction(notfication:)), name: NSNotification.Name(rawValue: "getdata1"), object: nil)
        self.specialTableView.rowHeight = UITableViewAutomaticDimension
        self.specialTableView.estimatedRowHeight = 200
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(sender:)), for: .valueChanged)
        specialTableView.addSubview(refreshControl)
        
    }
    
    @IBAction func specialbtnACTION(_ sender: UIButton) {
        
        USERDEFAULT.setValue("\(sender.tag)", forKey: "value")
        USERDEFAULT.synchronize()
        
        AppUtility.gotoHomeController()
    }
    
    @objc func refresh(sender:AnyObject) {
        // Code to refresh table view
        self.callAPIToGetPageOffer()
        refreshControl.endRefreshing()
    }
    
    @objc func yourfunction(notfication: NSNotification) {
        let dict = notfication.userInfo as! Dictionary<String, AnyObject>
        selectedIndex = dict["id"] as! String
        callAPIToGetPageOffer()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        if isFromLocations {
        //            return categoriesArray.count
        //        }
        return self.listOfWeek.count
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        selectedRow = indexPath.item
        collectionView.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCellID", for: indexPath) as! CategoryCollectionViewCell
        let dict : Dictionary<String, Any> = listOfWeek[indexPath.row]
        cell.categoryButton.setTitle(dict["name"] as! String, for: .normal)
        if selectedRow == indexPath.item{
            cell.categoryButton.backgroundColor = UIColor.init(red: 255/255.0, green: 194/255.0, blue: 0/255.0, alpha: 1)
        }else{
            cell.categoryButton.backgroundColor =  UIColor.init(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.1)
        }
       
        cell.categoryButton.tag = indexPath.row
        cell.categoryButton.isUserInteractionEnabled = false
       
        return cell
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- Helper methods
    func initialMethod() {
        //        self.navigationController?.navigationBar.topItem?.title = "Specials"
        //        self.navigationController?.navigationBar.topItem?.leftBarButtonItem = AppUtility.leftBarButton("menu", controller: self)
        //        self.navigationController?.navigationBar.topItem?.rightBarButtonItem = AppUtility.rightBarButton("bell", controller: self)
        self.navigationController?.navigationBar.isHidden = true
        // postArray = [["Icon":"lacrd","Title":"Tagesgericht","Subtitle":"@L'Arcade","Distance":"0.37 km","PostImage":"images1"],["Icon":"lacrd","Title":"Tagesgericht","Subtitle":"@L'Arcade","Distance":"0.37 km","PostImage":"images1"],["Icon":"lacrd","Title":"Tagesgericht","Subtitle":"@L'Arcade","Distance":"0.37 km","PostImage":"images1"],["Icon":"lacrd","Title":"Tagesgericht","Subtitle":"@L'Arcade","Distance":"0.37 km","PostImage":"images1"]]
    }
    
    // MARK:- IBAction methods
    @IBAction func menuButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func notificationButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        //        let notificationVC = mainStoryboard.instantiateViewController(withIdentifier: "MitteilungenViewControllerID") as! MitteilungenViewController
        //
        //
        //        self.navigationController?.pushViewController(notificationVC, animated: true)
        
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
        self.view.endEditing(true)
        let sideMenuController = APPDELEGATE.sideMenuController
        guard let centeralNavController = sideMenuController.centerViewController as? UINavigationController else {
            return
        }
        centeralNavController.popToRootViewController(animated: false)
        let filterVC = self.storyboard?.instantiateViewController(withIdentifier: "FilterViewControllerID") as! FilterViewController
        centeralNavController.setViewControllers([filterVC], animated: false)
        sideMenuController.closeSlider(.left, animated: true) { (_) in
            //do nothing
        }
    }
    
}

extension NewScreenViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCellID") as! CategoryTableViewCell
        cell.isFromLocations = false
        cell.listOfWeek = self.listOfWeek
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
//        let alert = UIAlertController.init(title: "Alert", message: "Work in progress.", preferredStyle: .alert)
//        let actio = UIAlertAction.init(title: "Ok", style: .default) { (action) in
//            self.dismiss(animated: true, completion: nil)
//
//        }
//        alert.addAction(actio)
//        self.present(alert, animated: true, completion: nil)
        let obj = list[indexPath.row]

        let locationsDetailsVC = mainStoryboard.instantiateViewController(withIdentifier: "ProgramDetailViewController") as! ProgramDetailViewController
        locationsDetailsVC.offerID = "\(obj["id"] ?? "" as AnyObject)"
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
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCellID") as! PostTableViewCell
        let dict = list[indexPath.row]
        
        // cell.iconImageView
        cell.postTitleLabel.text =  "\(dict["title"] ?? "" as AnyObject)"
        cell.postSubTitleLabel.text = "@\(dict["loc_name"] ?? "" as AnyObject)"
        cell.distanceLabel.text = ""
       // cell.postImageView.sd_setImage(with: URL.init(string: "https://www.test-it.eu/\(dict["image"] ?? "" as AnyObject)"), placeholderImage: #imageLiteral(resourceName: "Placeholder"), options: .continueInBackground, completed: nil)
        cell.iconImageView.sd_setImage(with: URL.init(string: "https://www.test-it.eu/\(dict["image"] ?? "" as AnyObject)"), placeholderImage: #imageLiteral(resourceName: "Square"), options: .continueInBackground, completed: nil)
        cell.distanceLabel.text = "\(dict["distance"] ?? "" as AnyObject)"
        if (dict["loc_open_cl"] as? String) == "on" {
            cell.onOffLabel.backgroundColor = UIColor.green
        }else{
            cell.onOffLabel.backgroundColor = UIColor.red
        }
        return cell
        
    }
    
    /*    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     let programDetailsVC = mainStoryboard.instantiateViewController(withIdentifier: "ProgramDetailViewController") as! ProgramDetailViewController
     self.navigationController?.pushViewController(programDetailsVC, animated: true)
     }
     */
    
    
    
    private func callAPIToGetWeekDay() {
        
        var dictParams = Dictionary<String,AnyObject>()
        //        dictParams["email"] = userInfo.email as AnyObject
        //        dictParams["registrationpassword"] = userInfo.password as AnyObject
        
        //create_user
        ServiceHelper.sharedInstance.createRequestToUploadDataWithString(additionalParams: dictParams, dataContent: nil, strName: "", strFileName: "", strType: "", apiName: "week.php") { (response, error) in
            if error != nil {
                MCCustomAlertController.alert(title: "", message: (error?.localizedDescription)!, buttons: ["OK"], tapBlock: { (action, index) in
                    //
                    
                })
                return
            }
            
            
            
            if (response != nil) {
                self.listOfWeek = response?.object(forKey:"data") as! [Dictionary<String, Any>]
                self.selectedIndex = self.listOfWeek[0].validatedValue("id", expected: "" as AnyObject) as! String
               // self.callAPIToGetPageOffer(index: 0)
                self.myCollectionView.reloadData()
                //                let status = response!.object(forKey: "Success") as! String
                //                if status == "True" {
                //
                //
                //                }else{
                ////                    MCCustomAlertController.alert(title: "", message: "Invalid credential.")
                //                }
                
            } else {
                MCCustomAlertController.alert(title: "", message: "Something went wrong.", buttons: ["OK"], tapBlock: { (action, index) in
                    //
                })
                return
            }
        }
    }
    
    private func callAPIToGetPageOffer() {
        var dictParams = Dictionary<String,AnyObject>()
        let lat = UserDefaults.standard.value(forKey: "lat") as! Double
        let long = UserDefaults.standard.value(forKey: "long") as! Double
        
        dictParams["longitude"] = String(long) as AnyObject
        dictParams["lat"] = String(lat) as AnyObject
        dictParams["days"] = "4" as AnyObject
       
        //create_user
        ServiceHelper.sharedInstance.createGetRequest(isShowHud: true, params: dictParams, apiName: "page_offer.php?location_id=\(locationID)") { (response, error) in
            if error != nil {
                MCCustomAlertController.alert(title: "", message: (error?.localizedDescription)!, buttons: ["OK"], tapBlock: { (action, index) in
                    //
                    
                })
                return
            }
            
            
            
            if (response != nil) {
                //   self.listOfWeek = response?.object(forKey:"data") as! [Dictionary<String, Any>]
                let respo:Dictionary<String, AnyObject> = response as! Dictionary<String, AnyObject>
                self.list = respo.validatedValue("data", expected: [] as AnyObject) as! [Dictionary<String, AnyObject>]
               // self.postArray = PageOfferInfo.getData(list: respo.validatedValue("data", expected: [] as AnyObject) as! [Dictionary<String, AnyObject>])
                self.specialTableView.reloadData()
                //                let status = response!.object(forKey: "Success") as! String
                //                if status == "True" {
                //
                //
                //                }else{
                ////                    MCCustomAlertController.alert(title: "", message: "Invalid credential.")
                //                }
                
            } else {
                MCCustomAlertController.alert(title: "", message: "Something went wrong.", buttons: ["OK"], tapBlock: { (action, index) in
                    //
                })
                return
            }
        }
    }
    
}


