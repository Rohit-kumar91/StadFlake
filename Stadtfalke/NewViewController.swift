//
//  NewViewController.swift
//  Stadtfalke
//
//  Created by Ashish Kr Singh on 23/12/18.
//  Copyright © 2018 Manoj Kumar Singh. All rights reserved.
//

import UIKit

class NewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var specialTableView: UITableView!
    var selectedIndex = ""
    var postArray = [PageOfferInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(self.yourfunction(notfication:)), name: NSNotification.Name(rawValue: "refreshOfferList"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.yourfunction1(notfication:)), name: NSNotification.Name(rawValue: "refreshOfferList1"), object: nil)
    }
    
    @objc func yourfunction(notfication: NSNotification) {
        let dict = notfication.userInfo as! Dictionary<String, AnyObject>
        postArray.removeAll()
        self.specialTableView.reloadData()
        selectedIndex = dict["id"] as! String
        callAPIToGetPageOffer(index: 0, searchStr: "")
    }
    
    @objc func yourfunction1(notfication: NSNotification) {
        let dict = notfication.userInfo as! Dictionary<String, AnyObject>
        postArray.removeAll()
        self.specialTableView.reloadData()
        let str = dict["str"] as! String
        callAPIToGetPageOffer(index: 0, searchStr: str)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let obj = postArray[indexPath.row]
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "goToDetails"), object: nil, userInfo: ["id":obj.id])
//        let locationsDetailsVC = mainStoryboard.instantiateViewController(withIdentifier: "ProgramDetailViewController") as! ProgramDetailViewController
//        locationsDetailsVC.offerID = obj.id
//        ///APPDELEGATE.navigationController.pushViewController(locationsDetailsVC, animated: true)
//
//
//
//        let sideMenuController = APPDELEGATE.sideMenuController
//        guard let centeralNavController = sideMenuController.centerViewController as? UINavigationController else {
//            return
//        }
//        centeralNavController.popToRootViewController(animated: false)
//
//        centeralNavController.setViewControllers([locationsDetailsVC], animated: false)
//        sideMenuController.closeSlider(.left, animated: true) { (_) in
//            //do nothing
//        }
//
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCellID") as! PostTableViewCell
        let dict = postArray[indexPath.row]
        
        // cell.iconImageView
        cell.postTitleLabel.text = dict.title
        cell.postSubTitleLabel.text = "@\(dict.locationName)"
        cell.distanceLabel.text = ""
        cell.postImageView.sd_setImage(with: URL.init(string: dict.image), placeholderImage: #imageLiteral(resourceName: "Placeholder"), options: .continueInBackground, completed: nil)
        cell.iconImageView.sd_setImage(with: URL.init(string: dict.locationLogo), placeholderImage: #imageLiteral(resourceName: "Placeholder"), options: .continueInBackground, completed: nil)
        cell.distanceLabel.text = dict.distance
        if dict.locationOnOff == "on" {
            cell.onOffLabel.backgroundColor = UIColor.green
        }else{
            cell.onOffLabel.backgroundColor = UIColor.red
        }
        return cell
        
    }
    
    
    private func callAPIToGetPageOffer(index : Int, searchStr : String) {
        var dictParams = Dictionary<String,AnyObject>()
        dictParams["days_id"] = selectedIndex as AnyObject
        
        
        
        guard let lat = UserDefaults.standard.value(forKey: "lat") as? Double else { return }
        guard let long = UserDefaults.standard.value(forKey: "long") as? Double else { return }
        
        dictParams["longitude"] = String(long) as AnyObject
        dictParams["lat"] = String(lat) as AnyObject
        dictParams["search"] = searchStr as AnyObject
        dictParams["distance"] = "\(UserDefaults.standard.value(forKey: "distance") ?? "")" as AnyObject
        dictParams["category"] = "\(UserDefaults.standard.value(forKey: "category") ?? "")" as AnyObject
        dictParams["status"] = "\(UserDefaults.standard.value(forKey: "status") ?? "")" as AnyObject
        
        
        //create_user
        ServiceHelper.sharedInstance.createGetRequest(isShowHud: true, params: dictParams, apiName: "page_offer.php") { (response, error) in
            if error != nil {
                MCCustomAlertController.alert(title: "", message: (error?.localizedDescription)!, buttons: ["OK"], tapBlock: { (action, index) in
                    //
                    
                })
                return
            }
            
            
            
            if (response != nil) {
                //   self.listOfWeek = response?.object(forKey:"data") as! [Dictionary<String, Any>]
                let respo:Dictionary<String, AnyObject> = response as! Dictionary<String, AnyObject>
                
                self.postArray = PageOfferInfo.getData(list: respo.validatedValue("data", expected: [] as AnyObject) as! [Dictionary<String, AnyObject>])
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
