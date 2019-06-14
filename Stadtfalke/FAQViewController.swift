//
//  FAQViewController.swift
//  Stadtfalke
//
//  Created by Manoj Kumar Singh on 15/06/18.
//  Copyright © 2018 Manoj Kumar Singh. All rights reserved.
//

import UIKit
import SwiftyJSON

class FAQViewController: UIViewController {
    @IBOutlet weak var tabBarView: UIView!
    @IBOutlet weak var tabBarHeightCons: NSLayoutConstraint!
    var dict = Dictionary<String, AnyObject>()
    
    var isItemSelectionVC = Bool()

    override func viewDidLoad() {
        super.viewDidLoad()
        //tabBarHeightCons.constant = isItemSelectionVC ? 0 : 49

        self.navigationController?.isNavigationBarHidden = true
        
        // Do any additional setup after loading the view.
    }
    
    
    
   

    
    @IBAction func specialbtnACTION(_ sender: UIButton) {
        
        USERDEFAULT.setValue("\(sender.tag)", forKey: "value")
        USERDEFAULT.synchronize()
        
        AppUtility.gotoHomeController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- IBAction methods
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

}

extension FAQViewController :UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FAQTableViewCell") as! FAQTableViewCell
        if indexPath.row == 0 {
            cell.sepratorView.isHidden = false
            cell.quesAnsLabel.text = dict.validatedValue("question", expected: "" as AnyObject) as? String
        }else{
            cell.sepratorView.isHidden = true
            cell.quesAnsLabel.text = dict.validatedValue("answer", expected: "" as AnyObject) as? String
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}
