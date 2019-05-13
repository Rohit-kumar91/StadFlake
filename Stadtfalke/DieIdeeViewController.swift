//
//  DieIdeeViewController.swift
//  Stadtfalke
//
//  Created by Manoj Kumar Singh on 18/06/18.
//  Copyright © 2018 Manoj Kumar Singh. All rights reserved.
//

import UIKit
import SwiftyJSON

class DieIdeeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var tabBarHeightCons: NSLayoutConstraint!
    var isItemSelectionVC = Bool()
    var textData = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // tabBarHeightCons.constant = isItemSelectionVC ? 0 : 49
        // Do any additional setup after loading the view.
        callAPI()
    }
    
    @IBAction func specialbtnACTION(_ sender: UIButton) {
        
        USERDEFAULT.setValue("\(sender.tag)", forKey: "value")
        USERDEFAULT.synchronize()
        
        AppUtility.gotoHomeController()
    }
    
    
    private func callAPI() {
        
        let dictParams = [
            "tag" : "die_idee"
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
                print(jsonResponse)
                self.textData = jsonResponse["data"]["content"].stringValue
                self.myTableView.reloadData()
                
            } else {
                MCCustomAlertController.alert(title: "", message: "Something went wrong.", buttons: ["OK"], tapBlock: { (action, index) in
                    //
                })
                return
            }
        }
    }

    
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 1
    }
    
   
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelTableViewCell") as! LabelTableViewCell
        cell.textViewText.text = textData.htmlToString
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- IBAction methods
    @IBAction func menuButtonAction(_ sender: UIButton) {
        if isItemSelectionVC {
            self.navigationController?.popViewController(animated: true)
        }else {
            self.toggleSlider()
        }
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

    
//    private func callAPI() {
//        let dictParams = Dictionary<String,AnyObject>()
//
//        let apiName = "s_page.php?title=die"
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
//
//
//            if (response != nil) {
//                let status = response!.object(forKey: "success") as! String
//                if status == "true" {
//
//                    let str = ((response?.object(forKey: "data") as! Dictionary<String,AnyObject>).validatedValue("content", expected: "" as AnyObject) as! String).replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
//                    print(str)
//
//                    self.descriptionLabel.text = str
//                    self.myTableView.reloadData()
//
//
//                }else{
//                    //MCCustomAlertController.alert(title: "", message: "Location not available.")
//
//                }
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

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
