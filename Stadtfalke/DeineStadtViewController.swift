//
//  ViewController.swift
//  Stadtfalke
//
//  Created by Manoj Kumar Singh on 12/06/18.
//  Copyright © 2018 Manoj Kumar Singh. All rights reserved.
//

import UIKit

class DeineStadtViewController: UIViewController {
     var dict = [Dictionary<String, AnyObject>]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //callAPIToGetCityList()
    }
    
    
    @IBAction func specialbtnACTION(_ sender: UIButton) {
        
        USERDEFAULT.setValue("\(sender.tag)", forKey: "value")
        USERDEFAULT.synchronize()
        
        AppUtility.gotoHomeController()
    }
    
    @IBAction func chooseCityButtonAction(_ sender: UIButton) {
        
        var optionList = [String]()
        
        for dic in Singleton.instance.citiesArray {
            optionList.append(dic["name"].stringValue)
        }
        
       // let optL = ["mainz"]
        
        RPicker.selectOption(title: "Deine Stadt", hideCancel: true, dataArray: optionList, selectedIndex: 0) { (selctedText, atIndex) in
            
            APPDELEGATE.window = UIWindow.init(frame: UIScreen.main.bounds)
            APPDELEGATE.navigationController.navigationBar.isHidden = true
            APPDELEGATE.window?.rootViewController = APPDELEGATE.sideMenuController
            APPDELEGATE.window?.makeKeyAndVisible()

            Singleton.instance.citySlug = Singleton.instance.citiesArray[atIndex]["slug"].stringValue
            UserDefaults.standard.setValue(Singleton.instance.citySlug, forKey: "saveSlug")
            
            //self.callApiToInsertCityID(cityId: Singleton.instance.citiesArray[atIndex]["id"].stringValue)
        }
    }
    
    func callApiToInsertCityID(cityId: String) {
        
        UserDefaults.standard.set(cityId, forKey: "cityid")
        UserDefaults.standard.set(UIDevice.current.identifierForVendor!.uuidString, forKey: "udid")
        
        UserDefaults.standard.synchronize()
        let dictParams = Dictionary<String,AnyObject>()
        
        let apiName = "insert_dev.php?&city=\(cityId)&dev_id=\(UserDefaults.standard.value(forKey: "udid") ?? "")"
        
        ServiceHelper.sharedInstance.createGetRequest(isShowHud: false, params: dictParams, apiName: apiName) { (response, error) in
            if error != nil {
                MCCustomAlertController.alert(title: "", message: (error?.localizedDescription)!, buttons: ["OK"], tapBlock: { (action, index) in
                    //
                    
                })
                
                return
            }
            
            if (response != nil) {
                MCCustomAlertController.alert(title: "Info", message: "Deine Stadtauswahi ist aktiv.")
                USERDEFAULT.set(true, forKey: "isFirstTime")
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
        //        dictParams["email"] = userInfo.email as AnyObject
        //        dictParams["registrationpassword"] = userInfo.password as AnyObject
        
        //create_user
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

