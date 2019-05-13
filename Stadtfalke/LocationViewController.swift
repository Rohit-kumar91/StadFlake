//
//  LocationViewController.swift
//  Stadtfalke
//
//  Created by Manoj Kumar Singh on 15/06/18.
//  Copyright © 2018 Manoj Kumar Singh. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var speisekarteBt: UIButton!
    @IBOutlet weak var getrankekarteBt: UIButton!
    @IBOutlet weak var wochenkarteBt: UIButton!
    @IBOutlet weak var fruhstuckskarteBt: UIButton!
    
    var locationID = ""
    var selectDictArray = [Dictionary<String,AnyObject>]()
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        speisekarteBt.layer.cornerRadius = 20
        speisekarteBt.clipsToBounds = true
        
        getrankekarteBt.layer.cornerRadius = 20
        getrankekarteBt.clipsToBounds = true
        
        wochenkarteBt.layer.cornerRadius = 20
        wochenkarteBt.clipsToBounds = true
        
        fruhstuckskarteBt.layer.cornerRadius = 20
        fruhstuckskarteBt.clipsToBounds = true
        // Do any additional setup after loading the view.
        self.callAPIToGetPageOffer()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(sender:)), for: .valueChanged)
        myTableView.addSubview(refreshControl)
        
    }
    
    @objc func refresh(sender:AnyObject) {
        // Code to refresh table view
        self.callAPIToGetPageOffer()
        refreshControl.endRefreshing()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func specialbtnACTION(_ sender: UIButton) {
        
        USERDEFAULT.setValue("\(sender.tag)", forKey: "value")
        USERDEFAULT.synchronize()
        
        AppUtility.gotoHomeController()
    }

    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return selectDictArray.count
    }
   
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "BTNTableViewCell") as! BTNTableViewCell
        let dict = self.selectDictArray[indexPath.row]
        cell.btn.setTitle((dict.validatedValue("title", expected: "" as AnyObject) as! String), for: .normal)
        cell.btn.layer.cornerRadius = cell.btn.frame.size.height / 2
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objvc = MyWebViewViewController.init(nibName: "MyWebViewViewController", bundle: nil)
        let dict = self.selectDictArray[indexPath.row]
        objvc.requestURL = "https://www.test-it.eu/\(dict["pdf"] ?? "" as AnyObject)"
        self.navigationController?.pushViewController(objvc, animated: true)
       // self.present(objvc, animated: true, completion: nil)
    }
    
    private func callAPIToGetPageOffer() {
        var dictParams = Dictionary<String,AnyObject>()
        dictParams["location_id"] = locationID as AnyObject
        
        //create_user
        ServiceHelper.sharedInstance.createGetRequest(isShowHud: true, params: dictParams, apiName: "pdf.php") { (response, error) in
            if error != nil {
                MCCustomAlertController.alert(title: "", message: (error?.localizedDescription)!, buttons: ["OK"], tapBlock: { (action, index) in
                    //
                })
                return
            }
            
            if (response != nil) {
                //   self.listOfWeek = response?.object(forKey:"data") as! [Dictionary<String, Any>]
                guard let responseDict = response as? Dictionary<String, AnyObject> else{
                    return
                }
                
                if (responseDict.validatedValue("success", expected: "" as AnyObject) as! String) == "true"{
                    self.selectDictArray = responseDict.validatedValue("data", expected: [] as AnyObject) as! [Dictionary<String,AnyObject>]
                   self.myTableView.reloadData()
                }
                
               // self.postArray = PageOfferInfo.getData(list: respo.validatedValue("data", expected: [] as AnyObject) as! [Dictionary<String, AnyObject>])
               // self.specialTableView.reloadData()
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
