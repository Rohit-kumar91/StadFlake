//
//  LocationsListViewController.swift
//  Stadtfalke
//
//  Created by Manoj Singh on 28/06/18.
//  Copyright © 2018 Manoj Kumar Singh. All rights reserved.
//

import UIKit

class LocationsListViewController: UIViewController {

    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet weak var locationsListTableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var postArray = Array<Dictionary<String, String>>()
    var locationID = ""
    var locationArray = [Dictionary<String, AnyObject>]()
    let refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        initialMethod()
        self.callAPIToGetLocation()
        // Do any additional setup after loading the view.
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(sender:)), for: .valueChanged)
        locationsListTableView.addSubview(refreshControl)
        
    }
    
    @objc func refresh(sender:AnyObject) {
        // Code to refresh table view
        self.callAPIToGetLocation()
        refreshControl.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- Helper methods
    func initialMethod() {
        self.navigationController?.navigationBar.isHidden = true
        postArray = [["Icon":"lacrd","Title":"Tagesgericht","Subtitle":"@L'Arcade","Distance":"0.37 km","PostImage":"images1"],["Icon":"lacrd","Title":"Tagesgericht","Subtitle":"@L'Arcade","Distance":"0.37 km","PostImage":"images1"],["Icon":"lacrd","Title":"Tagesgericht","Subtitle":"@L'Arcade","Distance":"0.37 km","PostImage":"images1"],["Icon":"lacrd","Title":"Tagesgericht","Subtitle":"@L'Arcade","Distance":"0.37 km","PostImage":"images1"]]
    }
    
    // MARK:- IBAction methods
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
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
    
    @IBAction func specialbtnACTION(_ sender: UIButton) {
        
        USERDEFAULT.setValue("\(sender.tag)", forKey: "value")
        USERDEFAULT.synchronize()
        
        AppUtility.gotoHomeController()
    }
    
  //  http://testing.net.in/JSON/page_offer.php?location_id=51

    private func callAPIToGetLocation() {
        let dictParams = Dictionary<String,AnyObject>()
        let apiName = "page_offer.php?location_id=\(locationID)"
        ServiceHelper.sharedInstance.createGetRequest(isShowHud: true, params: dictParams, apiName: apiName) { (response, error) in
            if error != nil {
                MCCustomAlertController.alert(title: "", message: (error?.localizedDescription)!, buttons: ["OK"], tapBlock: { (action, index) in
                    //
                    
                })
                return
            }
            
            
            
            if (response != nil) {
                let status = response!.object(forKey: "success") as! String
                if status == "true" {
                    if response!.object(forKey:"data") == nil{
                        return
                    }
                    self.locationArray = response!.object(forKey:"data") as! [Dictionary<String, AnyObject>]
                    self.locationsListTableView.reloadData()

                }else{
                    //MCCustomAlertController.alert(title: "", message: "Location not available.")
//                    self.locationsTableView.reloadData()
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

extension LocationsListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryTableViewCellID") as! CategoryTableViewCell
        cell.isFromLocations = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCellID") as! PostTableViewCell
        let dict = locationArray[indexPath.row]
        
        cell.iconImageView.sd_setImage(with: URL.init(string: "https://www.test-it.eu/\(dict.validatedValue("loc_logo", expected: "" as AnyObject) as! String)"), placeholderImage: #imageLiteral(resourceName: "Placeholder"), options: .continueInBackground, completed: nil)
        cell.postTitleLabel.text = dict.validatedValue("title", expected: "" as AnyObject) as! String
        cell.postSubTitleLabel.text = dict.validatedValue("loc_name", expected: "" as AnyObject) as! String
        cell.distanceLabel.text = dict.validatedValue("distance", expected: "" as AnyObject) as! String
        return cell
        
    }
    
}
