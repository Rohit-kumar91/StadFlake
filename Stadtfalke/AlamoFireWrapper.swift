//
//  AlamofireWrapper.swift
//  AlamofireDemo2
//
//  Created by iMark_IOS on 31/05/18.
//  Copyright © 2018 iMark_IOS. All rights reserved.
//

import UIKit
import Alamofire
//import SwiftyJSON

protocol LoginServiceAlamofire:class {
    func LoginResults(receivedDict: NSDictionary)
    func LoginError()
}

class connectivity {
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()!.isReachable
        
    }
}

class AlamoFireWrapper: NSObject {    
    class var sharedInstance: AlamoFireWrapper{
        struct Singleton{
            static let instance = AlamoFireWrapper()
        }
        return Singleton.instance
    }
    
    let customManager = Alamofire.SessionManager.default
    let setIndicatorTimeInterval:Double = 60
    
    //MARK:- get Api
    func getOnlyApi(action:String, onSuccess: @escaping(DataResponse<Any>) -> Void, onFailure: @escaping(Error) -> Void){
        
        let url : String = action
        
        print(url)
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON {
            (response:DataResponse<Any>) in
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                 //   print("response = ",response.result.value!)
                    onSuccess(response)
                    
                }
                break
            case .failure(_):
                onFailure(response.result.error!)
                print("error",response.result.error!)
                break
                
            }
        }
    }
    
    //MARK:- Post Api
    func getPost(action:String,param: [String:Any], onSuccess: @escaping(DataResponse<Any>) -> Void, onFailure: @escaping(Error) -> Void){
        
        let url : String = baseURL + action
        print(url)
        
        Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseJSON {
            (response:DataResponse<Any>) in
            switch(response.result) {
            case .success(_):
                if response.result.value != nil{
                 //   print("response = ",response.result.value!)
                    onSuccess(response)
                    
                }
                break
            case .failure(_):
                onFailure(response.result.error!)
            //    print("error",response.result.error!)
                break
                
            }
        }
    }
    
    //MARK: MULTIPART API
    func getPostMultipart(action:String,param: [String:Any],imageData: Data?, onSuccess: @escaping(DataResponse<Any>) -> Void, onFailure: @escaping(Error) -> Void){
       
     //   print(baseURL+action)        
       // print(imageData)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in param {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            
            }
            if imageData != nil {
                if let data = imageData{
                    multipartFormData.append(data, withName: "userProfilePic", fileName: "user_Profile_Pic.jpeg", mimeType: "image/png")
                }                
            }
           
        }, to: baseURL+action)
            
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                  //  print(progress)
                })
                upload.responseJSON { DataResponse in
                    
                    if DataResponse.result.value != nil {
                        onSuccess(DataResponse)
                    }
                    else
                    {
                        onFailure(DataResponse.result.error!)
                    }
                }
            case .failure(_):
                //onFailure(result as! Error)
                break
            }
        }
    }
}
