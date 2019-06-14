//
//  MenuViewController.swift
//  Stadtfalke
//
//  Created by Manoj Singh on 18/06/18.
//  Copyright © 2018 Manoj Kumar Singh. All rights reserved.
//

import UIKit
import MessageUI

class MenuViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var topBtn: UIButton!

    let menuArray = ["Partner Login","Specials","Mitteilungen","Die Idee","Locations","Dein Stadtfalke","Impressum","Partner Werden","FAQ"]
    
    let menu_Array = ["Home","Die Idee","Partner Werden","FAQ","Impressum","Datenschutz", "Feedback"]
    
    
    
    var dict = [Dictionary<String, AnyObject>]()
    let composeVC = MFMailComposeViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.callAPIToGetCityList()
        topBtn.layer.cornerRadius = 6
        
        composeVC.mailComposeDelegate = self
        composeVC.setToRecipients(["feedback@stadtfalke.com"])
        composeVC.setSubject("Stadtfalke: Feedback")
    }

    @IBAction func topBtnAction(_ sender: Any) {
        
        
        let sideMenuController = APPDELEGATE.sideMenuController
        sideMenuController.closeSlider(.left, animated: true) { (_) in
            //do nothing
        }
        
        
        var optionList = [String]()
        for dic in Singleton.instance.citiesArray {
            optionList.append(dic["name"].stringValue)
        }
        
        
        // let optL = ["mainz"]
        RPicker.selectOption(title: "Deine Stadt", hideCancel: true, dataArray: optionList, selectedIndex: 0) { (selctedText, atIndex) in
            Singleton.instance.citySlug = Singleton.instance.citiesArray[atIndex]["slug"].stringValue
            //self.callApiToInsertCityID(cityId: Singleton.instance.citiesArray[atIndex]["id"].stringValue)
            self.topBtn.setTitle(Singleton.instance.citiesArray[atIndex]["slug"].stringValue, for: .normal)
            NotificationCenter.default.post(name: Notification.Name("refreshNotificationData"), object: nil)

        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension MenuViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu_Array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SingleLabelTableViewCellID") as! SingleLabelTableViewCell
        cell.filteTitleLabel.text = menu_Array[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let sideMenuController = APPDELEGATE.sideMenuController
        guard let centeralNavController = sideMenuController.centerViewController as? UINavigationController else {
            return
        }
        centeralNavController.popToRootViewController(animated: false)
        
        switch indexPath.row {
            
        case 0:
            
            let mainViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            centeralNavController.setViewControllers([mainViewController], animated: false)
            sideMenuController.closeSlider(.left, animated: true) { (_) in
                //do nothing
            }
            break
            
        case 1:
            
            let dieIdeeVC = self.storyboard?.instantiateViewController(withIdentifier: "DieIdeeViewControllerID") as! DieIdeeViewController
            centeralNavController.setViewControllers([dieIdeeVC], animated: false)
            sideMenuController.closeSlider(.left, animated: true) { (_) in
                //do nothing
            }
            
//            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//            centeralNavController.setViewControllers([loginVC], animated: false)
//            sideMenuController.closeSlider(.left, animated: true) { (_) in
//                //do nothing
//            }
            break

        case 2:
            
            let mitteilungenVC = self.storyboard?.instantiateViewController(withIdentifier: "PartnerWerdenViewController") as! PartnerWerdenViewController
            centeralNavController.setViewControllers([mitteilungenVC], animated: false)
            sideMenuController.closeSlider(.left, animated: true) { (_) in
                //do nothing
            }
            
           
            
//            USERDEFAULT.setValue("0", forKey: "value")
//            USERDEFAULT.synchronize()
//
//            AppUtility.gotoHomeController()
            
//            let tabBarVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
//            centeralNavController.setViewControllers([tabBarVC], animated: false)
//            sideMenuController.closeSlider(.left, animated: true) { (_) in
//                //do nothing
//            }
            break

        case 3:
            
            let faqQuesVC = self.storyboard?.instantiateViewController(withIdentifier: "FAQQuesViewControllerID") as! FAQQuesViewController
            centeralNavController.setViewControllers([faqQuesVC], animated: false)
            sideMenuController.closeSlider(.left, animated: true) { (_) in
                //do nothing
            }
            
            
            break
        case 4:
            
            
            
            let impressumVC = self.storyboard?.instantiateViewController(withIdentifier: "ImpressumViewControllerID") as! ImpressumViewController
            centeralNavController.setViewControllers([impressumVC], animated: false)
            sideMenuController.closeSlider(.left, animated: true) { (_) in
                //do nothing
            }
            break

        case 5:
            
            let dieIdeeVC = self.storyboard?.instantiateViewController(withIdentifier: "DatenschutzViewController") as! DatenschutzViewController
            centeralNavController.setViewControllers([dieIdeeVC], animated: false)
            sideMenuController.closeSlider(.left, animated: true) { (_) in
                //do nothing
            }
            
            //USERDEFAULT.setValue("1", forKey: "value")
            //USERDEFAULT.synchronize()
            
            //AppUtility.gotoHomeController()
//            let locationsVC = self.storyboard?.instantiateViewController(withIdentifier: "LocationsViewControllerID") as! LocationsViewController
//            centeralNavController.setViewControllers([locationsVC], animated: false)
//            sideMenuController.closeSlider(.left, animated: true) { (_) in
//                //do nothing
//            }
            break
        case 6:
         
            
            guard MFMailComposeViewController.canSendMail() else {
                return
            }
            
            composeVC.setMessageBody("", isHTML: false)
            
            self.present(composeVC, animated: true, completion: nil)
            
        
//            let deineStadtVC = self.storyboard?.instantiateViewController(withIdentifier: "YourCityViewControllerID") as! YourCityViewController
//            centeralNavController.setViewControllers([deineStadtVC], animated: false)
//            sideMenuController.closeSlider(.left, animated: true) { (_) in
//                //do nothing
//            }
            break
        case 7:
            let impressumVC = self.storyboard?.instantiateViewController(withIdentifier: "ImpressumViewControllerID") as! ImpressumViewController
            centeralNavController.setViewControllers([impressumVC], animated: false)
            sideMenuController.closeSlider(.left, animated: true) { (_) in
                //do nothing
            }
            break
        case 8:
            let partnerWerdenVC = self.storyboard?.instantiateViewController(withIdentifier: "PartnerWerdenViewControllerID") as! PartnerWerdenViewController
            centeralNavController.setViewControllers([partnerWerdenVC], animated: false)
            sideMenuController.closeSlider(.left, animated: true) { (_) in
                //do nothing
            }
            break
        case 9:
            let faqQuesVC = self.storyboard?.instantiateViewController(withIdentifier: "FAQQuesViewControllerID") as! FAQQuesViewController
            centeralNavController.setViewControllers([faqQuesVC], animated: false)
            sideMenuController.closeSlider(.left, animated: true) { (_) in
                //do nothing
            }
            break
//            let programDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "ProgramDetailViewController") as! ProgramDetailViewController
//            centeralNavController.setViewControllers([programDetailVC], animated: false)
//            sideMenuController.closeSlider(.left, animated: true) { (_) in
//                //do nothing
//            }
         //   break
        case 10:
            let faqQuesVC = self.storyboard?.instantiateViewController(withIdentifier: "FAQQuesViewControllerID") as! FAQQuesViewController
            centeralNavController.setViewControllers([faqQuesVC], animated: false)
            sideMenuController.closeSlider(.left, animated: true) { (_) in
                //do nothing
            }
            break
        case 11:
//            let itemSelectionVC = self.storyboard?.instantiateViewController(withIdentifier: "ItemSelectionViewControllerID") as! ItemSelectionViewController
//            centeralNavController.setViewControllers([itemSelectionVC], animated: false)
//            sideMenuController.closeSlider(.left, animated: true) { (_) in
//                //do nothing
//            }
            break
        case 12:
            
            break
        default:
            break
        }
    }
    
    func launchEmail() {
        
        let emailTitle = ""
        
        let messageBody = ""
        
        let toRecipents = ["kontakt@stadtfalke.com"]
        let mc: MFMailComposeViewController = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        mc.setSubject(emailTitle)
        mc.setMessageBody(messageBody, isHTML: false)
        mc.setToRecipients(toRecipents)
        self.present(mc, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("Mail cancelled")
        case .saved:
            print("Mail saved")
        default:
            break
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func commonButtonAction(_ sender: UIButton) {
        switch sender.tag {
        case 101:
            self.toggleSlider()
            break
        case 102:
            let facebookURL = NSURL(string: "https://www.facebook.com/stadtfalke")!
            
            if UIApplication.shared.canOpenURL(facebookURL as URL) {
                UIApplication.shared.openURL(facebookURL as URL)
            }
            break
        case 103:
            let facebookURL = NSURL(string: "https://www.instagram.com/stadtfalke_official")!
            
            if UIApplication.shared.canOpenURL(facebookURL as URL) {
                UIApplication.shared.openURL(facebookURL as URL)
            }
            break
        case 104:
            self.launchEmail()
            break
        default:
            
            break
        }
    }
    
    func callApiToInsertCityID(cityId: String) {
        UserDefaults.standard.set(cityId, forKey: "cityid")
        UserDefaults.standard.set(UIDevice.current.identifierForVendor!.uuidString, forKey: "udid")
        
        UserDefaults.standard.synchronize()
        let dictParams = Dictionary<String,AnyObject>()
        
        let apiName = "insert_dev.php?&city=\(cityId)&dev_id=\(UserDefaults.standard.value(forKey: "udid") ?? "")"
        
        ServiceHelper.sharedInstance.createGetRequest(isShowHud: true, params: dictParams, apiName: apiName) { (response, error) in
            if error != nil {
                MCCustomAlertController.alert(title: "", message: (error?.localizedDescription)!, buttons: ["OK"], tapBlock: { (action, index) in
                    //
                })
                return
            }
            
            
            
            if (response != nil) {
                MCCustomAlertController.alert(title: "Info", message: "Deine Stadtauswahi ist aktiv.")
            } else {
                MCCustomAlertController.alert(title: "", message: "Something went wrong.", buttons: ["OK"], tapBlock: { (action, index) in
                    //
                })
                return
            }
        }
    }
    
    
    
    private func callAPIToGetCityList() {
        var dictParams = Dictionary<String,AnyObject>()
        
        ServiceHelper.sharedInstance.createRequestToUploadDataWithString(additionalParams: dictParams, dataContent: nil, strName: "", strFileName: "", strType: "", apiName: "city.php") { (response, error) in
            if error != nil {
                MCCustomAlertController.alert(title: "", message: (error?.localizedDescription)!, buttons: ["OK"], tapBlock: { (action, index) in
                    //
                    
                })
                return
            }
            
            
            
            if (response != nil) {
                self.dict = response?.object(forKey:"data") as! [Dictionary<String, AnyObject>]
                
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
