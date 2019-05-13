//
//  FilterInfo.swift
//  Stadtfalke
//
//  Created by Ashish Kr Singh on 24/10/18.
//  Copyright © 2018 Manoj Kumar Singh. All rights reserved.
//

import UIKit

class FilterInfo: NSObject {

//    "success": "true",
//    "data": [
//    {
//    "heading": "Sortieren nach",
//    "value": [
//    {
//    "title": "Zufalling",
//    "value": "false",
//    "select": "true"
//    },
    var heading = ""
    var value = [FilterInfo]()
    var title = ""
    var value2 = ""
    var select = false
    var infoSelect = false
    
    class func getFilterList(list:[Dictionary<String, AnyObject>]) -> [FilterInfo] {
    
        var tempList = [FilterInfo]()
        
        for dict in list{
            let obj = FilterInfo()
            obj.heading = dict.validatedValue("heading", expected: "" as AnyObject) as! String
            obj.value = FilterInfo.getFilterItemList(list: dict.validatedValue("value", expected: [] as AnyObject) as! [Dictionary<String, AnyObject>])
            obj.infoSelect = true
            tempList.append(obj)
        }
        
        return tempList
    }
    
    class func getFilterItemList(list:[Dictionary<String, AnyObject>]) -> [FilterInfo] {
        
        var tempList = [FilterInfo]()
        
        for dict in list{
            let obj = FilterInfo()
            obj.title = dict.validatedValue("title", expected: "" as AnyObject) as! String
            obj.value2 = dict.validatedValue("value", expected: "" as AnyObject) as! String
            obj.select = (dict.validatedValue("select", expected: "" as AnyObject) as! String == "true") ? true : false
            tempList.append(obj)
        }
        return tempList
    }
    

}
