//
//  MitteilungenViewController.swift
//  Stadtfalke
//
//  Created by Manoj Singh on 19/06/18.
//  Copyright © 2018 Manoj Kumar Singh. All rights reserved.
//

import UIKit

class MitteilungenViewController: UIViewController {

    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet weak var mitteilungenTableView: UITableView!
    
    var locationsArray = Array<Dictionary<String, String>>()
    var locationList = [Dictionary<String, Any>]()
    var isFromMenu = false
    var refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
       // initialMethod()
        
        self.mitteilungenTableView.tableFooterView = UIView()
        if isFromMenu == true {
            self.navigationTitleLabel.text = "Push-Nachricht"

        }else{
            self.navigationTitleLabel.text = "Mitteilungen"

        }
        self.callAPIToGetWeekDay()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(sender:)), for: .valueChanged)
        mitteilungenTableView.addSubview(refreshControl)
    }
    
    @objc func refresh(sender:AnyObject) {
        // Code to refresh table view
        self.callAPIToGetWeekDay()
        refreshControl.endRefreshing()
    }

    // MARK:- Helper methods
    func initialMethod() {
        locationsArray = [["Icon":"get","Title":"URBAN BIRDZ @Gutleut","Description":"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod "],["Icon":"lacrd","Title":"URBAN BIRDZ @L'Arcade","Description":"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed da."],["Icon":"get","Title":"URBAN BIRDZ @Gutleut","Description":"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex a."],["Icon":"lacrd","Title":"URBAN BIRDZ @L'Arcade","Description":"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do ur. Excepteur sint occaecat cu deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."],["Icon":"get","Title":"URBAN BIRDZ @Gutleut","Description":"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempo. Duism odioque civiuda."],["Icon":"lacrd","Title":"URBAN BIRDZ @L'Arcade","Description":"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incidina aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliqu legum odioque civiuda."],["Icon":"get","Title":"URBAN BIRDZ @Gutleut","Description":"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore e"],["Icon":"lacrd","Title":"URBAN BIRDZ @L'Arcade","Description":"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."]]
    }

    // MARK:- IBAction methods
    @IBAction func menuButtonAction(_ sender: UIButton) {
        USERDEFAULT.setValue("\(sender.tag)", forKey: "value")
        USERDEFAULT.synchronize()
        
        AppUtility.gotoHomeController()
        
        //self.toggleSlider()
        
        //APPDELEGATE.navigationController.popViewController(animated: true)
    
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
    
    @IBAction func specialbtnACTION(_ sender: UIButton) {
        
        USERDEFAULT.setValue("\(sender.tag)", forKey: "value")
        USERDEFAULT.synchronize()
        
        AppUtility.gotoHomeController()
    }
    
    private func callAPIToGetWeekDay() {
        var dictParams = Dictionary<String,AnyObject>()
        dictParams["dev_id"] = UIDevice.current.identifierForVendor!.uuidString as AnyObject
        
     print(dictParams)
        //create_user
        ServiceHelper.sharedInstance.createGetRequest(isShowHud: true, params: dictParams, apiName: isFromMenu == true ? "push_msg.php" : "push.php") { (response, error) in
            if error != nil {
                //                MCCustomAlertController.alert(title: "", message: (error?.localizedDescription)!, buttons: ["OK"], tapBlock: { (action, index) in
                //                    //
                //
                //                })
                return
            }
            
            
            
            if (response != nil) {
                
                let status = response!.object(forKey: "success") as! String
                if status == "true" {
                    self.locationList = response?.object(forKey:"data") as! [Dictionary<String, Any>]
                    
                    self.mitteilungenTableView.reloadData()
                    
                }else{
                    MCCustomAlertController.alert(title: "", message: "Invalid credential.")
                }
                
            } else {
                //                MCCustomAlertController.alert(title: "", message: "Something went wrong.", buttons: ["OK"], tapBlock: { (action, index) in
                //                    //
                //                })
                return
            }
        } 
    }
    
//    private func callAPIToGetWeekDay() {
//        let dictParams = Dictionary<String,AnyObject>()
//        //        dictParams["email"] = userInfo.email as AnyObject
//        //        dictParams["registrationpassword"] = userInfo.password as AnyObject
//        let apiName = "push.php?&dev_id=\(UserDefaults.standard.value(forKey: "udid") ?? "")"
//        ServiceHelper.sharedInstance.createGetRequest(isShowHud: true, params: dictParams, apiName: apiName) { (response, error) in
//            if error != nil {
//                MCCustomAlertController.alert(title: "", message: (error?.localizedDescription)!, buttons: ["OK"], tapBlock: { (action, index) in
//                    //
//
//                })
//                return
//            }
//
//
//
//            if (response != nil) {
//                self.locationList = response?.object(forKey:"data") as! [Dictionary<String, Any>]
//                self.mitteilungenTableView.reloadData()
//                //                let status = response!.object(forKey: "Success") as! String
//                //                if status == "True" {
//                //
//                //
//                //                }else{
//                ////                    MCCustomAlertController.alert(title: "", message: "Invalid credential.")
//                //                }
//
//            } else {
//                MCCustomAlertController.alert(title: "", message: "Something went wrong.", buttons: ["OK"], tapBlock: { (action, index) in
//                    //
//                })
//                return
//            }
//        }
//    }

}

extension MitteilungenViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCellID") as! PostTableViewCell
       
        let dict : Dictionary<String,Any> = locationList[indexPath.row]
        
       // print(dict)
        
        cell.iconImageView.sd_setImage(with: URL.init(string: "https://www.test-it.eu/\(dict["loc_img"] as! String)"), placeholderImage: #imageLiteral(resourceName: "Square"), options: .continueInBackground, completed: nil)
        cell.postTitleLabel.text = "\(dict["title"] as! String) @ \(dict["loc_title"] as! String)"
        
        if dict["time"] as? String != nil {
            cell.timeLbl.text! = dict["time"] as? String ?? ""
            
        }
        
        cell.distanceLabel.text = dict["sub_title"] as! String
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let locationsDetailsVC = mainStoryboard.instantiateViewController(withIdentifier: "ProgramDetailViewController") as! ProgramDetailViewController
        locationsDetailsVC.offerID = self.locationList[indexPath.row].validatedValue("offer_id", expected: "" as AnyObject) as! String
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

}

extension UINavigationController {
    
    func backToViewController(viewController: Swift.AnyClass) {
        
        for element in viewControllers as Array {
            if element.isKind(of: viewController) {
                self.popToViewController(element, animated: true)
                break
            }
        }
    }
}



