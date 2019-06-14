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
    
    var specialBhutJadaNakreWalaArray = JSON()
    var specialNeMeriMarli = true
    var id = String()
    var citiesArray = [JSON]()
    var citySlug = String()
    var location_Id = ""
    var daysArray = [["day": "Monday","id" : 1, "dayName": "MONTAG"],
                     ["day": "Tuesday","id" : 2, "dayName": "DIENSTAG"],
                     ["day": "Wednesday","id" : 3, "dayName": "MITTWOCH"],
                     ["day": "Thrusday","id" : 4, "dayName": "DONNERSTAG"],
                     ["day": "Friday","id" : 5, "dayName": "FREITAG"],
                     ["day": "Saturday","id" : 6, "dayName": "SAMSTAG"],
                     ["day": "Sunday","id" : 7, "dayName": "SONNTAG"]]     
    
   var location_open_hours = "0"
   var distanceFilter = ""
   var category_id = ""
   var reloadCheck = false
   var categoryflag = false
   var specialViewReloadCheck = false
   var reloadIndex = 0
   var detailLocationID = ""
   var refresh = false
   var filterSelectedValues = [[JSON]]()
    var check = true
}
