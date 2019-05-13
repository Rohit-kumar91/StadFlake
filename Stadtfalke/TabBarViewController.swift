//
//  TabBarViewController.swift
//  Stadtfalke
//
//  Created by Manoj Kumar Singh on 17/06/18.
//  Copyright © 2018 Manoj Kumar Singh. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if USERDEFAULT.string(forKey: "value") == "0"{
            selectedIndex = 0
        }else if USERDEFAULT.string(forKey: "value") == "1"{
            selectedIndex = 1
        }else{
            selectedIndex = 2
        }
        // Do any additional setup after loading the view.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
