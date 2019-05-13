//
//  MyWebViewViewController.swift
//  Stadtfalke
//
//  Created by Ashish Kr Singh on 17/12/18.
//  Copyright © 2018 Manoj Kumar Singh. All rights reserved.
//

import UIKit

class MyWebViewViewController: UIViewController {
    @IBOutlet weak var myWebView: UIWebView!
    var requestURL  = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        if requestURL.count != 0 {
            let request = URLRequest(url: URL.init(string:requestURL )!)
            myWebView.loadRequest(request)
        }
        
    }
    

    @IBAction func closeBtnAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        //self.dismiss(animated: true, completion: nil)
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
