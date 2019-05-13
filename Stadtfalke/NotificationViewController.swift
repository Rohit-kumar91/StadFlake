//
//  NotificationViewController.swift
//  Stadtfalke
//
//  Created by Rohit Kumar on 06/05/19.
//  Copyright © 2019 Manoj Kumar Singh. All rights reserved.
//

import UIKit
import SwiftyJSON

class NotificationViewController: UIViewController {

    
    var responseData = [JSON]()
    
    @IBOutlet weak var notificationTableview: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callAPI()
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func callAPI() {
        ServiceHelper.sharedInstance.createGetRequest(isShowHud: true, params: [:], apiName: "api/notifications") { (response, error) in
            if error != nil {
                MCCustomAlertController.alert(title: "", message: (error?.localizedDescription)!, buttons: ["OK"], tapBlock: { (action, index) in
                })
                return
            }
            
            if (response != nil) {
                let jsonresponse = JSON(response as Any)
                self.responseData = jsonresponse["data"].arrayValue
                self.notificationTableview.dataSource = self
                self.notificationTableview.reloadData()
                
            } else {
                MCCustomAlertController.alert(title: "", message: "Something went wrong.", buttons: ["OK"], tapBlock: { (action, index) in
                })
                return
            }
        }
    }
}


extension NotificationViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return responseData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NotificationTableViewCell
        
        cell.notificationTittle.text = responseData[indexPath.row]["offer_info"]["name"].stringValue
        cell.notificationby.text = responseData[indexPath.row]["description"].stringValue
        
        let imageUrl = "http://83.137.194.211/stadtfalke" + responseData[indexPath.row]["offer_info"]["location_info"]["logo_media_image"]["path"].stringValue + "/" +
            responseData[indexPath.row]["offer_info"]["location_info"]["logo_media_image"]["name"].stringValue
        cell.imageNotification.sd_setImage(with: URL.init(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "Placeholder"), options: .continueInBackground, completed: nil)
        
        //Convert the date string to date format.
        let dateAsString = responseData[indexPath.row]["created_at"].stringValue
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: dateAsString)
        
        cell.notiifcationTime.text = date?.getElapsedInterval()
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Singleton.instance.citySlug = responseData[indexPath.row]["offer_info"]["location_info"]["slug"].stringValue
        Singleton.instance.location_Id = responseData[indexPath.row]["offer_info"]["location_id"].stringValue
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

extension Date {
    
    func getElapsedInterval() -> String {
        
        let interval = Calendar.current.dateComponents([.year, .month, .day], from: self, to: Date())
        
        if let year = interval.year, year > 0 {
            return year == 1 ? "\(year)" + " " + "year ago" :
                "\(year)" + " " + "years ago"
        } else if let month = interval.month, month > 0 {
            return month == 1 ? "\(month)" + " " + "month ago" :
                "\(month)" + " " + "months ago"
        } else if let day = interval.day, day > 0 {
            return day == 1 ? "\(day)" + " " + "day ago" :
                "\(day)" + " " + "days ago"
        } else {
            return "a moment ago"
        }
    }
}