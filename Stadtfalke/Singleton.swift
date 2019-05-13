//
//  Singleton.swift
//  Stadtfalke
//
//  Created by Rohit Prajapati on 22/04/19.
//  Copyright © 2019 Manoj Kumar Singh. All rights reserved.
//

import UIKit
import SwiftyJSON
class Singleton: NSObject {
    static let instance = Singleton()
    
    var id = String()
    var citiesArray = [JSON]()
    var citySlug = String()
    var location_Id = ""
    var daysArray = [["day": "Monday","id" : 1, "dayName": "Montag"],
                     ["day": "Tuesday","id" : 2, "dayName": "Dienstag"],
                     ["day": "Wednesday","id" : 3, "dayName": "Mittwoch"],
                     ["day": "Thrusday","id" : 4, "dayName": "Donnerstag"],
                     ["day": "Friday","id" : 5, "dayName": "Freitag"],
                     ["day": "Saturday","id" : 6, "dayName": "Samstag"],
                     ["day": "Sunday","id" : 7, "dayName": "Sonntag"]]
    
    
   var location_open_hours = "0"
   var distanceFilter = ""
   var category_id = ""
   var reloadCheck = false
   var reloadIndex = 0
   var detailLocationID = ""
}
