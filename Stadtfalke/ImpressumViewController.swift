//
//  ImpressumViewController.swift
//  Stadtfalke
//
//  Created by Manoj Singh on 29/06/18.
//  Copyright © 2018 Manoj Kumar Singh. All rights reserved.
//

import UIKit
import SwiftyJSON

class ImpressumViewController: UIViewController {
    
    @IBOutlet weak var myWebView: UIWebView!
    @IBOutlet weak var descriptionTextView: UITextView!

    
    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet weak var impressumTableView: UITableView!
    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var tabBarHeightCons: NSLayoutConstraint!

    var isItemSelectionVC = Bool()
    var str = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  tabBarHeightCons.constant = isItemSelectionVC ? 0 : 49
        // Do any additional setup after loading the view.
        callAPI()
//        impressumTableView.rowHeight = UITableViewAutomaticDimension
//        impressumTableView.estimatedRowHeight = 85
        
       // UITextView.appearance().linkTextAttributes = [ .foregroundColor: UIColor.red ]
        
       // descriptionTextView.linkTextAttributes = [NS]
     //   UITextView.appearance().linkTextAttributes = [ NSForegroundColorAttributeName: UIColor.red ]
       // UITextView.appearance().linkTextAttributes = [ NSForegroundColorAttributeName: UIColor.redColor() ]
        
//        let linkTextAttributes : [String : Any] = [
//            NSForegroundColorAttributeName: UIColor.red,
//            NSUnderlineColorAttributeName: UIColor.magenta,
//            NSUnderlineStyleAttributeName: NSUnderlineStyle.patternSolid.rawValue
//        ]
        
//        let linkTextAttributes: [String : Any] = [NSAttributedStringKey.foregroundColor.rawValue : UIColor.blue,
//                                                  NSAttributedStringKey.underlineColor.rawValue: UIColor.red]
//
//        self.descriptionTextView.linkTextAttributes = linkTextAttributes

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- IBAction methods
    @IBAction func menuButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if isItemSelectionVC {
            self.navigationController?.popViewController(animated: true)
        }else {
            self.toggleSlider()
        }
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
        
//        USERDEFAULT.setValue("\(sender.tag)", forKey: "value")
//        USERDEFAULT.synchronize()
//
//        AppUtility.gotoHomeController()
    }
    
    private func callAPI() {
        
        let dictParams = [
            "tag" : "impressum"
        ]
        
        let apiName = "api/cms-page"
        
        
        
        ServiceHelper.sharedInstance.createPostRequest(isShowHud: true, params: dictParams as [String : AnyObject], apiName: apiName) { (response, error) in
            if error != nil {
                MCCustomAlertController.alert(title: "", message: (error?.localizedDescription)!, buttons: ["OK"], tapBlock: { (action, index) in
                    //
                    
                })
                return
            }
            
            
            
            if (response != nil) {
                
                let jsonResponse = JSON(response as Any)
                
                
                self.descriptionTextView.setHTMLFromString(text: jsonResponse["data"]["content"].stringValue)
                //self.myWebView.loadHTMLString(jsonResponse["data"]["content"].stringValue, baseURL: nil)
                
//                let status = response!.object(forKey: "success") as! String
//                if status == "true" {
//
//                    self.str = (response?.object(forKey: "data") as! Dictionary<String,AnyObject>).validatedValue("content", expected: "" as AnyObject) as! String
//                  //  self.str.replaceString("\"<br>\"", withString: "\n")
//                   // self.myWebView.loadHTMLString(self.str, baseURL: nil)
//                    self.descriptionTextView.text = self.str
//                    self.impressumTableView.reloadData()
//
//                }else{
//                    //MCCustomAlertController.alert(title: "", message: "Location not available.")
//
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

//extension ImpressumViewController : UITableViewDelegate,UITableViewDataSource {
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//    
//    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat{
//        return UITableViewAutomaticDimension
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ImpressumTableViewCellID") as! ImpressumTableViewCell
//        
//        let str11 = self.str.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
//        cell.headingTitleLabel.text = str11
//        
//        return cell
//    }
//    
//}
