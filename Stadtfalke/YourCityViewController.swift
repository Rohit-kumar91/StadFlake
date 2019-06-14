//
//  YourCityViewController.swift
//  Stadtfalke
//
//  Created by Manoj Kumar Singh on 17/06/18.
//  Copyright © 2018 Manoj Kumar Singh. All rights reserved.
//

import UIKit
import SwiftyJSON

class YourCityViewController: UIViewController {

    @IBOutlet weak var yourCityTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet weak var yourCityTableView: UITableView!

    var yourCityArray = Array<Dictionary<String, String>>()
    var cityList = [Dictionary<String, AnyObject>]()
    let refreshControl = UIRefreshControl()
    var subscriptionArray = [JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print("Rohit")
        
        initialMethod()
        self.callAPIToGetLocationList()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(sender:)), for: .valueChanged)
        yourCityTableView.addSubview(refreshControl)
        
    }
    
    @objc func refresh(sender:AnyObject) {
        // Code to refresh table view
        self.callAPIToGetLocationList()
        refreshControl.endRefreshing()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.callAPIToGetLocationList()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- Helper methods
    func initialMethod() {
        yourCityArray = [["Icon":"get","Title":"Gutleut"],["Icon":"lacrd","Title":"L'Arcade"],["Icon":"get","Title":"Gutleut"],["Icon":"lacrd","Title":"L'Arcade"],["Icon":"get","Title":"Gutleut"],["Icon":"lacrd","Title":"L'Arcade"],["Icon":"get","Title":"Gutleut"],["Icon":"lacrd","Title":"L'Arcade"]]
    }
    
    // MARK:- IBAction methods
    @IBAction func menuButtonAction(_ sender: UIButton) {
        self.toggleSlider()
    }
    
    @IBAction func specialbtnACTION(_ sender: UIButton) {
        
        USERDEFAULT.setValue("\(sender.tag)", forKey: "value")
        USERDEFAULT.synchronize()
        
        AppUtility.gotoHomeController()
    }
    
    @IBAction func notificationButtonAction(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    private func callAPIToGetLocationList() {
      
        guard let udid = UserDefaults.standard.value(forKey: "current_UDID") else { return }
      

        let param = [
            "udid" : udid,
            "city_slug" : Singleton.instance.citySlug
        ]
        
//        let apiName = "dein.php?&city=\(UserDefaults.standard.value(forKey: "cityid") ?? "1")&dev_id=\(UserDefaults.standard.value(forKey: "udid") ?? "")"
       
        ServiceHelper.sharedInstance.createEncodedPostRequest(isShowHud: true, params:param as [String : AnyObject], apiName: "api/subscription") { (response, error) in
            if error != nil {
                MCCustomAlertController.alert(title: "", message: (error?.localizedDescription)!, buttons: ["OK"], tapBlock: { (action, index) in
                    //
                })
                return
            }
            
            
            if (response != nil) {
                
                let jsonresponse = JSON(response as Any)
                 self.subscriptionArray = jsonresponse["data"].arrayValue
                print(self.subscriptionArray)
                self.yourCityTableView.reloadData()
                
            } else {
                MCCustomAlertController.alert(title: "", message: "Something went wrong.", buttons: ["OK"], tapBlock: { (action, index) in
                    //
                })
                return
            }
        }
       
    }
    
    
    private func updateStatus(id: String, isOn: String, index: Int) {
        
        let param = [
            "subscription_id" : id,
            "status" : isOn
        ]
        
        
        print(param)
        
        ServiceHelper.sharedInstance.createEncodedPostRequest(isShowHud: true, params:param as [String : AnyObject], apiName: "api/unSubscribe") { (response, error) in
            if error != nil {
                MCCustomAlertController.alert(title: "", message: (error?.localizedDescription)!, buttons: ["OK"], tapBlock: { (action, index) in
                    //
                })
                return
            }
            
            
            if (response != nil) {
                
                let jsonresponse = JSON(response as Any)
                print(jsonresponse)
                
                if isOn == "1" {
                    self.subscriptionArray[index]["status"] = 0
                } else {
                    self.subscriptionArray[index]["status"] = 1
                }
                
                
                
                print(self.subscriptionArray)
                
                //self.yourCityTableView.reloadData()
                let indexPath = IndexPath(item: index, section: 0)
                self.yourCityTableView.reloadRows(at: [indexPath], with: .automatic)
                
            } else {
                MCCustomAlertController.alert(title: "", message: "Something went wrong.", buttons: ["OK"], tapBlock: { (action, index) in
                    //
                })
                return
            }
        }
        
    }
    
//    private func callAPIToChangeStatus(status: String, locaID: String) {
//        let dictParams = Dictionary<String,AnyObject>()
//        let apiName = "insert_dev.php?&city=\(UserDefaults.standard.value(forKey: "cityid") ?? "1")&dev_id=\(UserDefaults.standard.value(forKey: "udid") ?? "")&update=\(status)&loc_id=\(locaID)"
//
//
//        ServiceHelper.sharedInstance.createGetRequest(isShowHud: true, params: dictParams, apiName: apiName) { (response, error) in
//            if error != nil {
//                MCCustomAlertController.alert(title: "", message: (error?.localizedDescription)!, buttons: ["OK"], tapBlock: { (action, index) in
//                    //
//
//                })
//                return
//            }
//
//            if (response != nil) {
//                if (response?.object(forKey:"success") as! String) == "true"{
//                    self.callAPIToGetLocationList()
//                }
//
//            } else {
//                MCCustomAlertController.alert(title: "", message: "Something went wrong.", buttons: ["OK"], tapBlock: { (action, index) in
//                    //
//                })
//                return
//            }
//        }
//
//    }
    
    @objc func switchButtonAction(sender:UISwitch){
        let id = self.subscriptionArray[sender.tag]["id"].stringValue
        
        var check  = Int()
        if sender.isOn {
            check = 0
        } else {
            check = 1
        }
        
        updateStatus(id: id, isOn: String(check), index: sender.tag)
        
//        self.callAPIToChangeStatus(status: sender.isOn ? "true" : "false", locaID: dict.validatedValue("id", expected: "" as AnyObject) as! String)
    }

}

extension YourCityViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subscriptionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCellID") as! PostTableViewCell
        
        let urlString = "http://stadtfalke.com/" + subscriptionArray[indexPath.row]["location_info"]["logo_media_image"]["path"].stringValue + "/" +
            subscriptionArray[indexPath.row]["location_info"]["logo_media_image"]["name"].stringValue
        
        cell.iconImageView.sd_setImage(with: URL.init(string: urlString), placeholderImage: #imageLiteral(resourceName: "Square"), options: .continueInBackground, completed: nil)
        
         cell.iconImageView.layer.cornerRadius = 6
         cell.iconImageView.clipsToBounds = true
        cell.postTitleLabel.text = subscriptionArray[indexPath.row]["location_info"]["name"].stringValue
        cell.switchButton.tag = indexPath.row
        
        if subscriptionArray[indexPath.row]["status"].intValue == 1 {
            cell.switchButton.isOn = true
        } else {
            cell.switchButton.isOn = false
        }
            
        
        cell.switchButton.addTarget(self, action: #selector(self.switchButtonAction(sender:)), for: .touchUpInside)
        return cell
        
    }
    
}
