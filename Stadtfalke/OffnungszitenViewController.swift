//
//  OffnungszitenViewController.swift
//  Stadtfalke
//
//  Created by Manoj Kumar Singh on 19/06/18.
//  Copyright © 2018 Manoj Kumar Singh. All rights reserved.
//

import UIKit
import SwiftyJSON

class OffnungszitenViewController: UIViewController {

    @IBOutlet weak var myTableView: UITableView!
  
    var menuTimeArray = [JSON]()
    var menuRefineArray = [JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        for (index, value) in menuTimeArray.enumerated()  {
            
            if index % 2 == 0 {
                if value["status"].stringValue == "2" {
                    let datetime = [
                        "dayStatus" : "geschlossen",
                        "timing" : "",
                        "dayName" : value["week_day"]["name"].stringValue
                    ]
                    menuRefineArray.append(JSON(datetime))
                } else {
                    
                    var str = ""
                    if value["start_time"].stringValue != "00:00:00" || value["end_time"].stringValue != "00:00:00" {
                        str += timeFormatter(time: value["start_time"].stringValue) + " - " + timeFormatter(time: value["end_time"].stringValue )
                    }
                    
                    if menuTimeArray[index + 1]["start_time"].stringValue != "00:00:00" || menuTimeArray[index + 1]["end_time"].stringValue != "00:00:00" {
                        str +=  "\n" + timeFormatter(time: menuTimeArray[index + 1]["start_time"].stringValue) + " - " + timeFormatter(time: menuTimeArray[index + 1]["end_time"].stringValue )
                    }
                    
                    if str.isEmpty {
                        
                        let datetime = [
                            "dayStatus" : "geschlossen",
                            "timing" : "",
                            "dayName" : value["week_day"]["name"].stringValue
                        ]
                        
                        menuRefineArray.append(JSON(datetime))
                    } else {
                        
                        let datetime = [
                            "dayStatus" : "",
                            "timing" : str,
                            "dayName" : value["week_day"]["name"].stringValue
                        ]
                        
                        menuRefineArray.append(JSON(datetime))
                        
                    }
                }
            }
        }
        
        
        print(menuRefineArray)
        
        myTableView.reloadData()
        
     
    }
    
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- IBAction methods
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
   
    


}

extension OffnungszitenViewController :UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuRefineArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! OffnungszitenTableViewCell
       
        cell.day1Label.text = menuRefineArray[indexPath.row]["dayName"].stringValue
        
        if menuRefineArray[indexPath.row]["timing"].stringValue == "" {
            cell.timeLabel.text = menuRefineArray[indexPath.row]["dayStatus"].stringValue
        } else {
            cell.timeLabel.text = menuRefineArray[indexPath.row]["timing"].stringValue
        }
        
        
        return cell
    }
    
    
    func timeFormatter(time: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let timeInHMS = dateFormatter.date(from: time)
        
        dateFormatter.dateFormat = "HH:mm"
        let timeInHM = dateFormatter.string(from: timeInHMS!)
        
        return timeInHM
    }
    
}
