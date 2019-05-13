//
//  SpecialCarbonViewController.swift
//  Stadtfalke
//
//  Created by Ashish Kr Singh on 23/12/18.
//  Copyright © 2018 Manoj Kumar Singh. All rights reserved.
//

import UIKit
import CarbonKit

class SpecialCarbonViewController: UIViewController, CarbonTabSwipeNavigationDelegate {
    var carbonTabSwipeNavigation : CarbonTabSwipeNavigation!
    override func viewDidLoad() {
        super.viewDidLoad()

        let items = ["Features","Features","Features","Features","Features", "Products", "About"]
        carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: items, delegate: self)
        carbonTabSwipeNavigation.insert(intoRootViewController: self)
        carbonTabSwipeNavigation.toolbarHeight.constant = 0
        carbonTabSwipeNavigation.toolbar.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.yourfunction(notfication:)), name: NSNotification.Name(rawValue: "selectedIndex"), object: nil)
        
        
    }
    
    @objc func yourfunction(notfication: NSNotification) {
        
        let dict = notfication.userInfo as! Dictionary<String, AnyObject>
        let ind  = dict["id"] as! Int
        self.carbonTabSwipeNavigation.setCurrentTabIndex(UInt(ind), withAnimation: true)
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        return mainStoryboard.instantiateViewController(withIdentifier: "NewViewController") as! NewViewController
    }
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, didMoveAt index: UInt) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getIndexValue"), object: nil, userInfo: ["id":Int(index)])
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
