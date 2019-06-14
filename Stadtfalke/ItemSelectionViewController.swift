//
//  ItemSelectionViewController.swift
//  Stadtfalke
//
//  Created by Manoj Kumar Singh on 30/06/18.
//  Copyright © 2018 Manoj Kumar Singh. All rights reserved.
//

import UIKit

class ItemSelectionViewController: UIViewController {

    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var instagramButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var dropDownView: UIView!
    @IBOutlet weak var dropDownButton: UIButton!
    var dict = [Dictionary<String, AnyObject>]()

    let menuArray = ["Die Idee","FAQ","Partner werden","Kooperationspartner","Feedback","Partner Log-in","Impressum"]

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.callAPIToGetCityList()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func commonButtonAction(_ sender: UIButton) {
        switch sender.tag {
        case 101:
            self.toggleSlider()
            break
        case 102:
            break
        case 103:
            break
        case 104:
            break
        default:
            var optionList = [String]()
            
            for dic in dict{
                optionList.append(dic.validatedValue("name", expected: "" as AnyObject) as! String)
            }
            
            RPicker.selectOption(title: "Deine Stadt", hideCancel: true, dataArray: optionList, selectedIndex: 1) { (selctedText, atIndex) in
               
                self.callApiToInsertCityID(cityId: (self.dict[atIndex].validatedValue("id", expected: "" as AnyObject)) as! String)
            }
            
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

extension ItemSelectionViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SingleLabelTableViewCellID") as! SingleLabelTableViewCell
        cell.filteTitleLabel.text = menuArray[indexPath.row]
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
            let dieIdeeVC = self.storyboard?.instantiateViewController(withIdentifier: "DieIdeeViewControllerID") as! DieIdeeViewController
            dieIdeeVC.isItemSelectionVC = true
            self.navigationController?.pushViewController(dieIdeeVC, animated: true)
//            centeralNavController.setViewControllers([dieIdeeVC], animated: false)
//            sideMenuController.closeSlider(.left, animated: true) { (_) in
//                //do nothing
//            }
            break
            
        case 1:
            let faqQuesVC = self.storyboard?.instantiateViewController(withIdentifier: "FAQQuesViewControllerID") as! FAQQuesViewController
            faqQuesVC.isItemSelectionVC = true
            self.navigationController?.pushViewController(faqQuesVC, animated: true)

//            centeralNavController.setViewControllers([faqQuesVC], animated: false)
//            sideMenuController.closeSlider(.left, animated: true) { (_) in
//                //do nothing
//            }
            break
            
        case 2:
            let partnerWerdenVC = self.storyboard?.instantiateViewController(withIdentifier: "PartnerWerdenViewControllerID") as! PartnerWerdenViewController
            self.navigationController?.pushViewController(partnerWerdenVC, animated: true)

//            centeralNavController.setViewControllers([partnerWerdenVC], animated: false)
//            sideMenuController.closeSlider(.left, animated: true) { (_) in
//                //do nothing
//            }
            break
        case 3:
            DispatchQueue.main.async {
                self.showAlert()
            }
            break
            
        case 4:
            DispatchQueue.main.async {
                self.showAlert()
            }
            break
        case 5:
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            loginVC.isItemSelectionVC = true
            self.navigationController?.pushViewController(loginVC, animated: true)

//            centeralNavController.setViewControllers([loginVC], animated: false)
//            sideMenuController.closeSlider(.left, animated: true) { (_) in
//                //do nothing
//            }
            break
        case 6:
            let impressumVC = self.storyboard?.instantiateViewController(withIdentifier: "ImpressumViewControllerID") as! ImpressumViewController
            impressumVC.isItemSelectionVC = true
            self.navigationController?.pushViewController(impressumVC, animated: true)

//            centeralNavController.setViewControllers([impressumVC], animated: false)
//            sideMenuController.closeSlider(.left, animated: true) { (_) in
//                //do nothing
//            }
            break

        default:
            break
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Alert", message: "Work in progress", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
