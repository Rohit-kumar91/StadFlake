//
//  PageOfferInfo.swift
//  Stadtfalke
//
//  Created by Ashish Kr Singh on 08/08/18.
//  Copyright © 2018 Manoj Kumar Singh. All rights reserved.
//

import UIKit

class PageOfferInfo: NSObject {

    var author : String = ""
    var content : String = ""
    var date : String = ""
    var days : String = ""
    var end_date : String = ""
    var id : String = ""
    var image : String = ""
    var offer_type : String = ""
    var order : String = ""
    var page_content_filtered : String = ""
    var page_link : String = ""
    var page_mime_type : String = ""
    var page_modified_date : String = ""
    var page_modified_gmt : String = ""
    var page_name : String = ""
    var page_parent_id : String = ""
    var page_password : String = ""
    var page_type : String = ""
    var ping_status : String = ""
    var publish_date : String = ""
    var push_msg_id : String = ""
    var repeat_settings : String = ""
    var start_date : String = ""
    var title : String = ""
    var to_ping : String = ""
    var locationName : String = ""
    var locationLogo : String = ""
    var locationOnOff : String = ""
    var distance : String = ""

    class func getData(list:[Dictionary<String, AnyObject>]) -> [PageOfferInfo]{
    
        var tempList = [PageOfferInfo]()
        for dict in list{
            
            let obj = PageOfferInfo()
            obj.author = dict.validatedValue("author", expected: "" as AnyObject) as! String
            obj.content = dict.validatedValue("content", expected: "" as AnyObject) as! String
            obj.date = dict.validatedValue("date", expected: "" as AnyObject) as! String
            obj.days = dict.validatedValue("days", expected: "" as AnyObject) as! String
            obj.id = dict.validatedValue("id", expected: "" as AnyObject) as! String
            obj.image = "https://www.test-it.eu/\(dict.validatedValue("image", expected: "" as AnyObject) as! String)"
            obj.offer_type = dict.validatedValue("offer_type", expected: "" as AnyObject) as! String
            obj.order = dict.validatedValue("order", expected: "" as AnyObject) as! String
            obj.page_content_filtered = dict.validatedValue("page_content_filtered", expected: "" as AnyObject) as! String
            obj.page_link = dict.validatedValue("page_link", expected: "" as AnyObject) as! String
            obj.page_mime_type = dict.validatedValue("page_mime_type", expected: "" as AnyObject) as! String
            obj.page_modified_date = dict.validatedValue("page_modified_date", expected: "" as AnyObject) as! String
            obj.title = dict.validatedValue("title", expected: "" as AnyObject) as! String
            obj.locationName = dict.validatedValue("loc_name", expected: "" as AnyObject) as! String
            obj.locationLogo = "https://www.test-it.eu/\(dict.validatedValue("loc_logo", expected: "" as AnyObject) as! String)"
            obj.locationOnOff = dict.validatedValue("loc_open_cl", expected: "" as AnyObject) as! String
            obj.distance = dict.validatedValue("distance", expected: "" as AnyObject) as! String

            obj.start_date = dict.validatedValue("start_date", expected: "" as AnyObject) as! String
            tempList.append(obj)
        }
        return tempList
    }
}
