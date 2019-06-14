//
//  AboutUsViewController.swift
//  Stadtfalke
//
//  Created by Manoj Kumar Singh on 30/06/18.
//  Copyright © 2018 Manoj Kumar Singh. All rights reserved.
//

import UIKit
import GoogleMaps
import MessageUI
import SwiftyJSON

class AboutUsViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    
    @IBOutlet weak var myTableView: UITableView!
    
    
    var dictValue = JSON()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dictValue)
        
    }
    
 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK:- IBAction methods
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
   
    @IBAction func gmailBtnAction(_ sender: Any) {
        launchEmail()
    }
    
    
    @IBAction func facebookButton(_ sender: Any) {
        
        guard let url = URL(string: dictValue["facebook"].stringValue) else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    
    @IBAction func instagramButton(_ sender: Any) {
        
        guard let url = URL(string: dictValue["instragram"].stringValue) else {
            return //be safe
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    
    func launchEmail() {
        
      
    }
    
    private func mailComposeController(controller:MFMailComposeViewController, didFinishWithResult result:MFMailComposeResult, error:NSError) {
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
    
    
}

extension AboutUsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AboutUSTableViewCellID") as! AboutUSTableViewCell
        
        
        cell.locationName.text = dictValue["name"].stringValue
        cell.thirdLabel.text = dictValue["address"].stringValue
        
        cell.fourthLabel.isHidden = false
        cell.fourthLabel.text = dictValue["city_info"]["name"].stringValue + ", "  + dictValue["post_code"].stringValue
        
        cell.websiteLabel.text = ""
        cell.emailLabel.text = ""
        
        let str = dictValue["telephone"].stringValue
        cell.telephoneLabel.text = "Tel: " +  str.replaceString("/", withString: " ")
        
        
        let description = dictValue["description"].stringValue + dictValue["miscellaneous"].stringValue
        
        
        cell.myMapView.camera = GMSCameraPosition.camera(withLatitude: dictValue["latitude"].doubleValue, longitude: dictValue["longitude"].doubleValue, zoom: 15.0)
        let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: dictValue["latitude"].doubleValue, longitude: dictValue["longitude"].doubleValue))

        marker.map = cell.myMapView
        
        
        cell.descriptionlabel.setHTMLFromString(text: description)
        return cell
    }
}


