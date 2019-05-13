//
//  ServiceHelper.swift
//  MeClub
//
//  Created by Probir Chakraborty on 20/07/17.
//  Copyright © 2017 Mobiloitte. All rights reserved.
//

import Foundation
import Alamofire
final class ServiceHelper {
//    let baseURL = "http://ec2-52-1-133-240.compute-1.amazonaws.com/PROJECTS/IOSDatabase/trunk/services/web_services.php"
    
    
//     let baseURL = "http://meclub.powerupcloud.com/"
//     let baseURL = "http://meclub-puc.powerupcloud.com/"
       let baseURL =  "http://83.137.194.211/stadtfalke/public/"
    
    // Specifying the Headers we need
    class var sharedInstance: ServiceHelper {
        
        struct Static {
            static let instance = ServiceHelper()
        }
        return Static.instance
    }
    
    
    
    //Create Post and send request
    func createEncodedPostRequest(isShowHud: Bool, params: [String : AnyObject]!,apiName : String, completion: @escaping (_ response: AnyObject?, _ error: NSError?) -> Void)
    {
        if !kAppDelegate.checkReachablility() {
            completion(nil,NSError.init(domain: "Please check your internet connection!", code: 000, userInfo: nil))
            return
        }
        if isShowHud {
            showHud()
        }
        
        let url = self.baseURL + apiName
        let parameterDict = params as NSDictionary
        logInfo(message: "\n\n Request URL  >>>>>>\(url)")
        logInfo(message: "\n\n Request Parameters >>>>>>\n\(parameterDict)")
        
        var headers = HTTPHeaders()
        if UserDefaults.standard.value(forKey: kAccessToken) != nil {
            headers = [kAccess_Token: UserDefaults.standard.value(forKey: kAccessToken) as! String, "contentType" : "application/json"]
        }
        
        Alamofire.request(URL.init(string: url)!,
                          method: .post,
                          parameters: parameterDict as? Parameters,
                          encoding: URLEncoding.queryString,
                          headers: headers).responseJSON { response in
                            
            switch response.result {
            case .success(_):
                logInfo(message: "\nsuccess:\n Response From Server >>>>>>\n\(response)")
                RappleActivityIndicatorView.stopAnimation()
                completion(response.result.value as AnyObject?, nil)
            case .failure(_):
                logInfo(message: "\nfailure:\n failure Response From Server >>>>>>\n\(String(describing: response.result.error))")
                RappleActivityIndicatorView.stopAnimation()
                completion(nil, response.result.error as NSError?)
            }
        }
    }
    
    
    //Create Post and send request
    func createPostRequest(isShowHud: Bool, params: [String : AnyObject]!,apiName : String, completion: @escaping (_ response: AnyObject?, _ error: NSError?) -> Void)
    {
        if !kAppDelegate.checkReachablility() {
            completion(nil,NSError.init(domain: "Please check your internet connection!", code: 000, userInfo: nil))
            return
        }
        if isShowHud {
            showHud()
        }
        
        let url = self.baseURL + apiName
        let parameterDict = params as NSDictionary
        logInfo(message: "\n\n Request URL  >>>>>>\(url)")
        logInfo(message: "\n\n Request Parameters >>>>>>\n\(parameterDict)")

        var headers = HTTPHeaders()
        if UserDefaults.standard.value(forKey: kAccessToken) != nil {
            headers = [kAccess_Token: UserDefaults.standard.value(forKey: kAccessToken) as! String, "contentType" : "application/json"]
        }
        
        Alamofire.request(URL.init(string: url)!, method: HTTPMethod.post, parameters: parameterDict as? Parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(_):
                logInfo(message: "\nsuccess:\n Response From Server >>>>>>\n\(response)")
                RappleActivityIndicatorView.stopAnimation()
                completion(response.result.value as AnyObject?, nil)
            case .failure(_):
                logInfo(message: "\nfailure:\n failure Response From Server >>>>>>\n\(String(describing: response.result.error))")
                RappleActivityIndicatorView.stopAnimation()
                completion(nil, response.result.error as NSError?)
            }
        }
    }
    
    
    
    
    func createFormDataPostRequest(isShowHud: Bool, params: [String : AnyObject]!,apiName : String, completion: @escaping (_ response: AnyObject?, _ error: NSError?) -> Void)
    {
        if !kAppDelegate.checkReachablility() {
            completion(nil,NSError.init(domain: "Please check your internet connection!", code: 000, userInfo: nil))
            return
        }
        if isShowHud {
            showHud()
        }
        
        let url = self.baseURL + apiName
        let parameterDict = params as NSDictionary
        logInfo(message: "\n\n Request URL  >>>>>>\(url)")
        logInfo(message: "\n\n Request Parameters >>>>>>\n\(parameterDict)")
        
        var headers = HTTPHeaders()
        if UserDefaults.standard.value(forKey: kAccessToken) != nil {
            headers = [kAccess_Token: UserDefaults.standard.value(forKey: kAccessToken) as! String, "contentType" : "application/json"]
        }
        
        Alamofire.request(URL.init(string: url)!, method: HTTPMethod.post, parameters: parameterDict as? Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            switch response.result {
            case .success(_):
                logInfo(message: "\nsuccess:\n Response From Server >>>>>>\n\(response)")
                RappleActivityIndicatorView.stopAnimation()
                completion(response.result.value as AnyObject?, nil)
            case .failure(_):
                logInfo(message: "\nfailure:\n failure Response From Server >>>>>>\n\(String(describing: response.result.error))")
                RappleActivityIndicatorView.stopAnimation()
                completion(nil, response.result.error as NSError?)
            }
        }
    }
    
    
    
    //Create Get and send request
    func createGetRequest(isShowHud: Bool, params: [String : AnyObject]!,apiName : String, completion: @escaping (_ response: AnyObject?, _ error: NSError?) -> Void) {
        
        if !kAppDelegate.checkReachablility() {
            completion(nil,NSError.init(domain: "Please check your internet connection!", code: 000, userInfo: nil))
            return
        }
        if isShowHud {
            showHud()
        }
        
        let url = self.baseURL + apiName
     
        print(url)
        
        let parameterDict = params as Dictionary
        logInfo(message: "\n\n Request URL  >>>>>>\(url)")
        logInfo(message: "\n\n Request Parameters >>>>>>\n\(parameterDict)")
        var headers = HTTPHeaders()
        if UserDefaults.standard.value(forKey: kAccessToken) != nil {
            headers = [kAccess_Token: UserDefaults.standard.value(forKey: kAccessToken) as! String, "contentType" : "application/json"]
        }
        Alamofire.request(URL.init(string: url)!, method: HTTPMethod.get, parameters: parameterDict, encoding: URLEncoding.default, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(_):
                logInfo(message: "\nsuccess:\n Response From Server >>>>>>\n\(response)")
                RappleActivityIndicatorView.stopAnimation()
                completion(response.result.value as AnyObject?, nil)
            case .failure(_):
                logInfo(message: "\nfailure:\n failure Response From Server >>>>>>\n\(String(describing: response.result.error))")
                RappleActivityIndicatorView.stopAnimation()
                completion(nil, response.result.error as NSError?)
            }
        }
    }
    
    
    
    
    func createRequestToUploadDataWithString(additionalParams : Dictionary<String,Any>,dataContent : Data?,strName : String,strFileName : String,strType : String ,apiName : String,completion: @escaping (_ response: AnyObject?, _ error: NSError?) -> Void) {
        if !kAppDelegate.checkReachablility() {
            completion(nil,NSError.init(domain: "Please check your internet connection!", code: 000, userInfo: nil))
            return
        }
        self.showHud()
        let url = self.baseURL + apiName
        logInfo(message: "\n\n Request URL  >>>>>>\(url)")
        logInfo(message: "\n Param --- \(additionalParams)")
        var headers = HTTPHeaders()
       
        //headers = ["Content-Type" : "multipart/form-data"]
        let URL = try! URLRequest(url: url, method: .post, headers: headers)
        
        Alamofire.upload(multipartFormData: { (multipartData) in
            for (key,value) in additionalParams {
                multipartData.append("\(value)".data(using: .utf8)!, withName: key)
            }
            if dataContent != nil {
                multipartData.append(dataContent!, withName:strName, fileName: strFileName, mimeType: strType)
            }
        }, with: URL) { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    RappleActivityIndicatorView.stopAnimation()
                    logInfo(message: "\nresult -  \(response.result.value as AnyObject?)")
                    completion(response.result.value as AnyObject?, nil)
                }
                break
                
            case .failure(let encodingError):
                RappleActivityIndicatorView.stopAnimation()
                RappleActivityIndicatorView.stopAnimation(completionIndicator: .none, completionLabel: "", completionTimeout: 1.0)
                logInfo(message: "error - \(encodingError as NSError?)")
                
                completion(nil, encodingError as NSError?)
                break
            }
        }
    }
    
    func showHud() {
        let attribute = RappleActivityIndicatorView.attribute(style: RappleStyleCircle, tintColor: .white, screenBG: nil, progressBG: .black, progressBarBG: .lightGray, progreeBarFill: .yellow)
        RappleActivityIndicatorView.startAnimating(attributes: attribute)
    }
}
