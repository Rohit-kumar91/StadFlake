//
//  PartnerWerdenViewController.swift
//  Stadtfalke
//
//  Created by Manoj Kumar Singh on 19/06/18.
//  Copyright © 2018 Manoj Kumar Singh. All rights reserved.
//

import UIKit
import MessageUI
import SwiftyJSON

class PartnerWerdenViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var parterWardenCollectionView: UICollectionView!
    
    var reponseData = [JSON]()
    let composeVC = MFMailComposeViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        composeVC.mailComposeDelegate = self
        composeVC.setToRecipients(["partner@stadtfalke.com"])
        composeVC.setSubject("Stadtfalke: Partner werden")

        callAPI()
        // Do any additional setup after loading the view.
    }


    @IBAction func emailBtnAction(_ sender: Any) {
        //self.launchEmail()
        guard MFMailComposeViewController.canSendMail() else {
            return
        }
        
        composeVC.setMessageBody("", isHTML: false)
        self.present(composeVC, animated: true, completion: nil)
        
    }
    
    
    func launchEmail() {
        
        let emailTitle = "Support Request"
        
        let messageBody = ""
        
        let toRecipents = ["partner@stadtfalk.com"]
        let mc: MFMailComposeViewController = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        mc.setSubject(emailTitle)
        mc.setMessageBody(messageBody, isHTML: false)
        mc.setToRecipients(toRecipents)
        self.present(mc, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("Mail cancelled")
        case .saved:
            print("Mail saved")
        default:
            break
        }
        self.dismiss(animated: true, completion: nil)
    }

  
    @IBAction func menuButtonAction(_ sender: UIButton) {
     
        self.toggleSlider()
     
    }
    
    @IBAction func notificationButtonAction(_ sender: UIButton) {
       
    }
    
    
    private func callAPI() {
        
        let param = [
            "city_slug" : Singleton.instance.citySlug
        ]
        
        
        ServiceHelper.sharedInstance.createEncodedPostRequest(isShowHud: true, params:param as [String : AnyObject], apiName: "api/partners") { (response, error) in
            if error != nil {
                MCCustomAlertController.alert(title: "", message: (error?.localizedDescription)!, buttons: ["OK"], tapBlock: { (action, index) in
                    //
                })
                return
            }
            
            
            if (response != nil) {
                
                let jsonresponse = JSON(response as Any)
                self.reponseData = jsonresponse["data"].arrayValue
                self.parterWardenCollectionView.dataSource = self
                
            } else {
                MCCustomAlertController.alert(title: "", message: "Something went wrong.", buttons: ["OK"], tapBlock: { (action, index) in
                    //
                })
                return
            }
        }
    }

}

extension PartnerWerdenViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reponseData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ParterWardenCollectionViewCell
        
        cell.partnerName.text = reponseData[indexPath.item]["name"].stringValue
        
        let imageUrl = "http://83.137.194.211/stadtfalke" + reponseData[indexPath.row]["logo_media_image"]["path"].stringValue + "/" +
            reponseData[indexPath.row]["logo_media_image"]["name"].stringValue
        cell.parterImage.sd_setImage(with: URL.init(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "Placeholder"), options: .continueInBackground, completed: nil)
        
        return cell
        
    }
    
    
}
