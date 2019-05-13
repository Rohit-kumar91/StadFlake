//
//  TabViewViewController.swift
//  Stadtfalke
//
//  Created by Ashish Kr Singh on 28/06/18.
//  Copyright © 2018 Manoj Kumar Singh. All rights reserved.
//

import UIKit

class TabViewViewController: UIViewController {
    static let sharedinstance = TabViewViewController()
    
    @IBOutlet weak var tabView: UIView!
    var count = 0
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
    }

    @IBAction func locationBtnAction(_ sender: Any) {
        print("second");

    }
    
    @IBAction func specialBtnAction(_ sender: Any) {
        print("first");
    }
    @IBAction func thirdBtnAction(_ sender: Any) {
        print("third");

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
