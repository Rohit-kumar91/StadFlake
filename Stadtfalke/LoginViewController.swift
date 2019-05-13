//
//  LoginViewController.swift
//  Stadtfalke
//
//  Created by Ashish Kr Singh on 20/06/18.
//  Copyright © 2018 Manoj Kumar Singh. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tabBarHeightCons: NSLayoutConstraint!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginWebView: UIWebView!
    @IBOutlet weak var emailTextField: UITextField!
    
    var isItemSelectionVC = Bool()

    override func viewDidLoad() {
        super.viewDidLoad()
       // tabBarHeightCons.constant = isItemSelectionVC ? 0 : 49

        // Do any additional setup after loading the view.
        containerView.addShadow()
        
        loginWebView.loadRequest(URLRequest.init(url: URL.init(string: "https://www.test-it.eu/admin/welcome")!))
       }
    
    @IBAction func loginBtnAction(_ sender: Any) {
        self.view.endEditing(true)

        callAPIToLogin()
    }
    @IBAction func specialbtnACTION(_ sender: UIButton) {
        
        USERDEFAULT.setValue("\(sender.tag)", forKey: "value")
        USERDEFAULT.synchronize()
        
        AppUtility.gotoHomeController()
    }

    @IBAction func menuAction(_ sender: Any) {
        self.view.endEditing(true)
        
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

    private func callAPIToLogin() {
        var dictParams = Dictionary<String,AnyObject>()
        dictParams["email"] = emailTextField.text as AnyObject
        dictParams["password"] = passwordTextField.text as AnyObject
        
        //create_user
        ServiceHelper.sharedInstance.createRequestToUploadDataWithString(additionalParams: dictParams, dataContent: nil, strName: "", strFileName: "", strType: "", apiName: "login.php") { (response, error) in
            if error != nil {
                MCCustomAlertController.alert(title: "", message: (error?.localizedDescription)!, buttons: ["OK"], tapBlock: { (action, index) in
                    //
                    //
                })
                return
            }
            
            if (response != nil) {
               
                let status = response!.object(forKey: "success") as! String
                if status == "true" {
                    MCCustomAlertController.alert(title: "", message:"You have successfully login.", buttons: ["OK"], tapBlock: { (action, index) in
                    
                        let sideMenuController = APPDELEGATE.sideMenuController
                        guard let centeralNavController = sideMenuController.centerViewController as? UINavigationController else {
                            return
                        }
                        centeralNavController.popToRootViewController(animated: false)
                        let tabBarVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                        centeralNavController.setViewControllers([tabBarVC], animated: false)
                        sideMenuController.closeSlider(.left, animated: true) { (_) in
                            //do nothing
                        }
                        
                    })
                    
                    
                }else{
                    MCCustomAlertController.alert(title: "", message: "Invalid credential.")
                }
                
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
