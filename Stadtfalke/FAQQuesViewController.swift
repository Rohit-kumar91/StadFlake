//
//  FAQQuesViewController.swift
//  Stadtfalke
//
//  Created by Manoj Kumar Singh on 20/06/18.
//  Copyright © 2018 Manoj Kumar Singh. All rights reserved.
//

import UIKit
import  SwiftyJSON

class FAQQuesViewController: UIViewController {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var faqQuesTableView: UITableView!
    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var tabBarHeightCons: NSLayoutConstraint!
    var list = [JSON]()
    var isItemSelectionVC = Bool()
    var dataArray = ["Wer sind die Grunder von Standfalke?","Gibt es Stadtfalke auch in anderen Stadten?"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tabBarHeightCons.constant = isItemSelectionVC ? 0 : 49
        //self.callAPIToGetQuestionList()
        callAPI()
    }
    
    
    private func callAPI() {
        
        let apiName = "/api/faqs"
        ServiceHelper.sharedInstance.createGetRequest(isShowHud: true, params: [:], apiName: apiName) { (response, error) in
            if error != nil {
                MCCustomAlertController.alert(title: "", message: (error?.localizedDescription)!, buttons: ["OK"], tapBlock: { (action, index) in
                })
                return
            }
            
            
            
            if (response != nil) {
                
                let jsonResponse = JSON(response as Any)
                print(jsonResponse)
                self.list = jsonResponse["data"].arrayValue
                self.faqQuesTableView.reloadData()
                
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
    
    @IBAction func specialbtnACTION(_ sender: UIButton) {
       
        USERDEFAULT.setValue("\(sender.tag)", forKey: "value")
        USERDEFAULT.synchronize()

        AppUtility.gotoHomeController()
    }
    
//    private func callAPIToGetQuestionList() {
//        let dictParams = Dictionary<String,AnyObject>()
//
//        ServiceHelper.sharedInstance.createGetRequest(isShowHud: true, params: dictParams, apiName: "faq.php") { (response, error) in
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
//                //   self.listOfWeek = response?.object(forKey:"data") as! [Dictionary<String, Any>]
//                let respo:Dictionary<String, AnyObject> = response as! Dictionary<String, AnyObject>
//
//                self.list = respo.validatedValue("data", expected: [] as AnyObject) as! [Dictionary<String, AnyObject>]
//                self.faqQuesTableView.reloadData()
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

extension FAQQuesViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FAQTableViewCell") as! FAQTableViewCell
        
        cell.quesAnsLabel.text =  "Q\(indexPath.row + 1). " + list[indexPath.row]["question"].stringValue
        
        cell.answerLabel.text = list[indexPath.row]["answer"].stringValue
        return cell

    }
    
    
    
}
