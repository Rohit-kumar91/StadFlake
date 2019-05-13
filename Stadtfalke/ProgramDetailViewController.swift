//
//  ProgramDetailViewController.swift
//  Stadtfalke
//
//  Created by Manoj Kumar Singh on 20/06/18.
//  Copyright © 2018 Manoj Kumar Singh. All rights reserved.
//

import UIKit
import SwiftyJSON

class ProgramDetailViewController: UIViewController {
    
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var locationNameLabel: UILabel!

    @IBOutlet weak var noDataLbl: UILabel!
    
    
    var specialDetails = JSON()
    var dict: Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
    var offerID:String = ""
    //var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.myTableView.isHidden = true
        self.noDataLbl.isHidden = true
        
        print(specialDetails)
        
        //callAPITOGetPageOffer()
//        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
//        refreshControl.addTarget(self, action: #selector(self.refresh(sender:)), for: .valueChanged)
       // myTableView.addSubview(refreshControl)
        myTableView.estimatedRowHeight = 200
        myTableView.rowHeight = UITableViewAutomaticDimension
    }
    
//    @objc func refresh(sender:AnyObject) {
//        // Code to refresh table view
//        self.callAPITOGetPageOffer()
//        refreshControl.endRefreshing()
//    }
    @objc func callBtnAction(sender: UIButton){
        
        if sender.tag == 100{
            
            let str = specialDetails["location_info"]["telephone"].stringValue
            let phone = str.replacingOccurrences(of: "/", with: "-")
            if let phoneCallURL = URL(string: "tel://\(phone)") {
                
                UIApplication.shared.openURL(phoneCallURL)
                
                //UIApplication.shared.open(phoneCallURL)
//                
//                let application:UIApplication = UIApplication.shared
//                if (application.canOpenURL(phoneCallURL)) {
//                    if #available(iOS 10.0, *) {
//                        application.open(phoneCallURL, options: [:], completionHandler: nil)
//                    } else {
//                        // Fallback on earlier versions
//                    }
//                }
            }
        }else if sender.tag == 101{
            
        //    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "goToDetails"), object: nil, userInfo: ["id":dict["loc_id"] as! String])
            
            let locationsDetailsVC = mainStoryboard.instantiateViewController(withIdentifier: "LocationDetailsViewControllerID") as! LocationDetailsViewController
            
            let latitude = specialDetails["location_info"]["latitude"].doubleValue
            let longitude = specialDetails["location_info"]["longitude"].doubleValue
            locationsDetailsVC.lattitude = latitude
            locationsDetailsVC.longitude = longitude
            locationsDetailsVC.locationID = specialDetails["location_info"]["slug"].stringValue
            self.navigationController?.pushViewController(locationsDetailsVC, animated: true)
            
//            let sideMenuController = APPDELEGATE.sideMenuController
//            guard let centeralNavController = sideMenuController.centerViewController as? UINavigationController else {
//                return
//            }
//            centeralNavController.popToRootViewController(animated: false)
//
//            centeralNavController.setViewControllers([locationsDetailsVC], animated: false)
//            sideMenuController.closeSlider(.left, animated: true) { (_) in
//                //do nothing
//            }
        }
        else{
            
            if specialDetails["location_info"]["latitude"].stringValue.count == 0 {
                return
            }
            
            let latitude = specialDetails["location_info"]["latitude"].doubleValue
            let longitude = specialDetails["location_info"]["longitude"].doubleValue
            
            if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string:"comgooglemaps://?saddr=&daddr=\(latitude),\(longitude)&directionsmode=driving")!, options: [:], completionHandler: nil)
                } else {
                    let lat = latitude
                    let longi = longitude
                    
                    if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(lat),\(longi)&directionsmode=driving") {
                        UIApplication.shared.openURL(urlDestination)
                    }
                }
            } else {
                let lat = latitude
                let longi = longitude
                
                if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(lat),\(longi)&directionsmode=driving") {
                    UIApplication.shared.openURL(urlDestination)
                }
            }
        }
  
    }
    
    
    @IBAction func specialbtnACTION(_ sender: UIButton) {
        
        USERDEFAULT.setValue("\(sender.tag)", forKey: "value")
        USERDEFAULT.synchronize()
        AppUtility.gotoHomeController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func menuButtonAction(_ sender: UIButton) {
        USERDEFAULT.setValue("\(sender.tag)", forKey: "value")
        USERDEFAULT.synchronize()
        AppUtility.gotoHomeController()
        
       // self.navigationController?.popViewController(animated: true)
      //  self.toggleSlider()
    }

    @IBAction func notificationButtonAction(_ sender: UIButton) {
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
    
    
//    private func callAPITOGetPageOffer() {
//        var dictParams = Dictionary<String,AnyObject>()
//        dictParams["offer_id"] = offerID as AnyObject
//        
//        guard let lat = UserDefaults.standard.value(forKey: "lat") as? Double else { return }
//        guard let long = UserDefaults.standard.value(forKey: "long") as? Double else { return }
//        
//        dictParams["longitude"] = String(long) as AnyObject
//        dictParams["lat"] = String(lat) as AnyObject
//        
//        //        dictParams["registrationpassword"] = userInfo.password as AnyObject
//        
//        //create_user
//        ServiceHelper.sharedInstance.createGetRequest(isShowHud: true, params: dictParams, apiName: "offer_details.php") { (response, error) in
//            if error != nil {
//                //                MCCustomAlertController.alert(title: "", message: (error?.localizedDescription)!, buttons: ["OK"], tapBlock: { (action, index) in
//                //                    //
//                //
//                //                })
//                
//                self.noDataLbl.isHidden = false
//                self.myTableView.isHidden = true
//                return
//            }
//            if (response != nil) {
//                self.noDataLbl.isHidden = true
//                self.myTableView.isHidden = false
//                
//                //   self.listOfWeek = response?.object(forKey:"data") as! [Dictionary<String, Any>]
//                let respo:Dictionary<String, AnyObject> = response as! Dictionary<String, AnyObject>
//                self.dict = respo.validatedValue("data", expected: [:] as AnyObject) as! Dictionary<String, AnyObject>
//                self.myTableView.reloadData()
//                //                let status = response!.object(forKey: "Success") as! String
//                //                if status == "True" {
//                //
//                //
//                //                }else{
//                ////                    MCCustomAlertController.alert(title: "", message: "Invalid credential.")
//                //                }
//                
//            } else {
//                
//                self.noDataLbl.isHidden = false
//                self.myTableView.isHidden = true
//                //                MCCustomAlertController.alert(title: "", message: "Something went wrong.", buttons: ["OK"], tapBlock: { (action, index) in
//                //                    //
//                //                })
//                return
//            }
//        }
//    }
    
    
}

extension ProgramDetailViewController:UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
//    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
//        return kWindowHeight
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OffnungszitenTableViewCell") as! OffnungszitenTableViewCell
        cell.titleLabel.text =  specialDetails["name"].stringValue
        
        let string = specialDetails["description"].stringValue
        let str = string.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        print(str)
        //cell.descriptionLabel.text = specialDetails["description"].stringValue
        
        cell.descriptionLabel.setHTMLFromString(text: specialDetails["description"].stringValue)
        
        cell.locationNameLabel.text = "@\(specialDetails["location_info"]["name"].stringValue)"
        

        let imageUrl = "http://83.137.194.211/stadtfalke" + specialDetails["logo_media_image"]["path"].stringValue + "/" +
            specialDetails["logo_media_image"]["name"].stringValue
        
        cell.posterImageView.sd_setImage(with: URL.init(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "Placeholder"), options: .continueInBackground, completed: nil)
        
        
        let logoImage = "http://83.137.194.211/stadtfalke" + specialDetails["location_logo_media_img"]["path"].stringValue + "/" + specialDetails["location_logo_media_img"]["name"].stringValue
        cell.logoIconImageView.sd_setImage(with: URL.init(string: logoImage), placeholderImage: #imageLiteral(resourceName: "Placeholder"), options: .continueInBackground, completed: nil)
        
        if specialDetails["location_info"]["distance"].stringValue == "" {
            cell.addressLabel.text = "0.0" + "KM"
        } else {
            cell.addressLabel.text =   String(format: "%.2f", specialDetails["location_info"]["distance"].doubleValue) + " KM"
        }
        
        
        if specialDetails["location_opening_hours"].stringValue == "geöffnet" {
            cell.onOffImageView.backgroundColor = UIColor.green
        }else{
            cell.onOffImageView.backgroundColor = UIColor.red
        }
        
        cell.locationBtn.setTitle("Zu \(specialDetails["location_info"]["name"].stringValue) routen", for: .normal)
        cell.callBtn.tag = 100
        cell.callBtn.addTarget(self, action: #selector(self.callBtnAction(sender:)), for: .touchUpInside)
        cell.detailBtn.tag = 101
        cell.detailBtn.addTarget(self, action: #selector(self.callBtnAction(sender:)), for: .touchUpInside)
        cell.locationBtn.addTarget(self, action: #selector(self.callBtnAction(sender:)), for: .touchUpInside)

        return cell
    }
    
    
  
}

extension UILabel {
    func setHTMLFromString(text: String) {
        let modifiedFont = NSString(format:"<span style=\"font-family: \(self.font!.fontName); font-size: \(self.font!.pointSize)\">%@</span>" as NSString, text)
        
        let attrStr = try! NSAttributedString(
            data: modifiedFont.data(using: String.Encoding.unicode.rawValue, allowLossyConversion: true)!,
            options: [NSAttributedString.DocumentReadingOptionKey.documentType:NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil)
        
        self.attributedText = attrStr
    }
}

