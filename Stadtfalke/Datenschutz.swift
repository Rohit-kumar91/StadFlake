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

class DatenschutzViewController: UIViewController {
    
    var textData = String()
   
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
         super.viewDidLoad()
        
         callAPI()
    }
    
    
    private func callAPI() {
        
        let dictParams = [
            "tag" : "datenschutz"
        ]
        
        let apiName = "api/cms-page"
        
        ServiceHelper.sharedInstance.createPostRequest(isShowHud: true, params: dictParams as [String : AnyObject], apiName: apiName) { (response, error) in
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
                
                
                
//                let htmlData = NSString(string: self.textData).data(using: String.Encoding.unicode.rawValue)
//
//                let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
//
//                let attributedString = try! NSAttributedString(data: htmlData!, options: options, documentAttributes: nil)
                
               
                self.textView.setHTMLFromString(text: self.textData)
                
                
               // self.textView.attributedText = attributedString
                
                
            } else {
                MCCustomAlertController.alert(title: "", message: "Something went wrong.", buttons: ["OK"], tapBlock: { (action, index) in
                    //
                })
                return
            }
        }
    }
    
    
   

    @IBAction func menuButton(_ sender: Any) {
        self.toggleSlider()
    }
    
}



extension UITextView {
    func setHTMLFromString(text: String) {
        let modifiedFont = NSString(format:"<span style=\"font-family: \(self.font!.fontName); font-size: \(self.font!.pointSize)\">%@</span>" as NSString, text)
        
        let attrStr = try! NSAttributedString(
            data: modifiedFont.data(using: String.Encoding.unicode.rawValue, allowLossyConversion: true)!,
            options: [NSAttributedString.DocumentReadingOptionKey.documentType:NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil)
        
        self.attributedText = attrStr
    }
    
    
    func setHTMLFromStringInWhite(text: String) {
        let modifiedFont = NSString(format:"<span style=\"font-family: \(self.font!.fontName); color:White; font-size: \(self.font!.pointSize)\">%@</span>" as NSString, text)
        
        let attrStr = try! NSAttributedString(
            data: modifiedFont.data(using: String.Encoding.unicode.rawValue, allowLossyConversion: true)!,
            options: [NSAttributedString.DocumentReadingOptionKey.documentType:NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil)
        
        self.attributedText = attrStr
    }
}
