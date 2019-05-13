//
//  Datenschutz.swift
//  Stadtfalke
//
//  Created by Rohit Prajapati on 05/05/19.
//  Copyright © 2019 Manoj Kumar Singh. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class DatenschutzViewController: UIViewController, UIWebViewDelegate {
    
    var textData = String()
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
         super.viewDidLoad()
         self.webView.delegate = self
         callAPI()
    }
    
    
    private func callAPI() {
        
        let dictParams = [
            "tag" : "datenschutz"
        ]
        
        let apiName = "api/cms-page"
        
        ServiceHelper.sharedInstance.createPostRequest(isShowHud: false, params: dictParams as [String : AnyObject], apiName: apiName) { (response, error) in
            if error != nil {
                MCCustomAlertController.alert(title: "", message: (error?.localizedDescription)!, buttons: ["OK"], tapBlock: { (action, index) in
                    //
                    
                })
                return
            }
            
            
            
            if (response != nil) {
                
                let jsonResponse = JSON(response as Any)
                print(jsonResponse)
                self.textData = jsonResponse["data"]["content"].stringValue
                self.webView.loadHTMLString(jsonResponse["data"]["content"].stringValue, baseURL: nil)
                
                
            } else {
                MCCustomAlertController.alert(title: "", message: "Something went wrong.", buttons: ["OK"], tapBlock: { (action, index) in
                    //
                })
                return
            }
        }
    }
    
    
    func webViewDidStartLoad(_ : UIWebView) {
        loader.isHidden = false
        loader.startAnimating()
    }
    
    func webViewDidFinishLoad(_ : UIWebView) {
        loader.stopAnimating()
        loader.isHidden = true
    }

    @IBAction func menuButton(_ sender: Any) {
        self.toggleSlider()
    }
    
}
