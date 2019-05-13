//  AppUtility.swift
//  ProjectTemplate
//  Created by Raj Kumar Sharma on 04/04/16.
//  Copyright © 2016 2018 Mobiloitte. All rights reserved.

import UIKit

let authStoryboard = UIStoryboard(name: "Auth", bundle: nil)
let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
let settingsStoryboard = UIStoryboard(name: "Settings", bundle: nil)

let kAppColor = RGBA(r: 49, g: 118, b: 239, a: 1)
let kSeparatorColor = RGBA(r: 230, g: 230, b: 230, a: 1)
let kSeparatorNewColor = RGBA(r: 170, g: 170, b: 170, a: 0.3)

let KAppNavigationTitleFont = UIFont(name: "KohinoorDevanagari-Semibold", size: 17)
let KAppBoldTitleFont = UIFont(name: "Arial-BoldMT", size: 14)
let KAppFont = UIFont(name: "Arial", size: 16)
let kAppBackgroundColor = RGBA(r: 255, g: 194, b: 0, a: 1)
let kAppDarkColor = RGBA(r: 42, g: 42, b: 42, a: 1)

let showLog = true
let kAppDelegate = UIApplication.shared.delegate as! AppDelegate

let isDeviceHasCamera = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
let USERDEFAULT = UserDefaults.standard

let kWindowWidth = UIScreen.main.bounds.size.width
let kWindowHeight = UIScreen.main.bounds.size.height

struct DeviceType {
  
  static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
  static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
  static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
  static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
  static let IS_IPHONE_X          =  UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 812.0
  static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
  static let IS_IPAD_PRO          = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
}
enum UIUserInterfaceIdiom : Int {
  
  case Unspecified
  case Phone
  case Pad
}

struct ScreenSize {
  
  static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
  static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
  static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
  static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

// custom log
func logInfo(message: String, file: String = #file, function: String = #function, line: Int = #line, column: Int = #column) {
    if (showLog) {
        print("\(function): \(line): \(message)")
    }
}

//MARK:- HUD
func showHud() {
    let attribute = RappleActivityIndicatorView.attribute(style: RappleStyleCircle, tintColor: .white, screenBG: nil, progressBG: .black, progressBarBG: .lightGray, progreeBarFill: .yellow)
    RappleActivityIndicatorView.startAnimating(attributes: attribute)
}

func hideHud() {
    RappleActivityIndicatorView.stopAnimation()
    RappleActivityIndicatorView.stopAnimation(completionIndicator: .none, completionLabel: "", completionTimeout: 1.0)
}

var currentTimestamp: String {
    return "\(Date().timeIntervalSince1970)"
}


func setArialBoldFont(size: CGFloat) -> UIFont {
    return UIFont(name: "Arial-BoldMT", size: size)!
}

func setArialRegularFont(size: CGFloat) -> UIFont {
    return UIFont(name: "Arial", size: size)!
}

// MARK: - Useful functions

func RGBA(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
    return UIColor(red: (r/255.0), green: (g/255.0), blue: (b/255.0), alpha: a)
}

func UIColorFromRGB(rgbValue: UInt) -> UIColor {
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

func getViewWithTag(tag:NSInteger, view:UIView) -> UIView {
    return view.viewWithTag(tag)!
}

func hexStringToUIColor(_ hex: String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

func delay(delay: Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}

func degreesToRadians(degrees: CGFloat) -> CGFloat {
    return degrees * (CGFloat.pi / 180)
}

func radiansToDegress(radians: CGFloat) -> CGFloat {
    return radians * 180 / CGFloat.pi
}

func setShadowview(newView:UIView)  {
    newView.layer.cornerRadius = 5.0
    newView.layer.masksToBounds = false
    newView.layer.shadowColor = UIColor.gray.cgColor
    newView.layer.shadowOffset = CGSize.zero
    newView.layer.shadowOpacity = 0.5
    newView.layer.shadowRadius = 2.0
    newView.layer.borderColor = UIColor.clear.cgColor
}

func setShadowviewWithBorderColor(newView:UIView)  {
    newView.layer.cornerRadius = 5.0
    newView.layer.masksToBounds = false
    newView.layer.shadowColor = UIColor.gray.cgColor
    newView.layer.shadowOffset = CGSize.zero
    newView.layer.shadowOpacity = 0.5
    newView.layer.shadowRadius = 2.0
    newView.layer.borderColor = UIColor.darkGray.cgColor
}

func getStringFromDate(date : Date) -> String {
    
    let dateFormat = DateFormatter.init()
    dateFormat.timeZone = NSTimeZone.local
    dateFormat.dateFormat = "dd-MM-yyyy"
    
    return dateFormat.string(from: date)
}

func roundedPolygonPath(rect: CGRect, lineWidth: CGFloat, sides: NSInteger, cornerRadius: CGFloat, rotationOffset: CGFloat = 0)
    -> UIBezierPath {
        let path = UIBezierPath()
        let theta: CGFloat = CGFloat(2.0 * .pi) / CGFloat(sides) // How much to turn at every corner
        // let offset: CGFloat = cornerRadius * tan(theta / 2.0)     // Offset from which to start rounding corners
        let width = min(rect.size.width, rect.size.height)        // Width of the square
        
        let center = CGPoint(x: rect.origin.x + width / 2.0, y: rect.origin.y + width / 2.0)
        
        // Radius of the circle that encircles the polygon
        // Notice that the radius is adjusted for the corners, that way the largest outer
        // dimension of the resulting shape is always exactly the width - linewidth
        let radius = (width - lineWidth + cornerRadius - (cos(theta) * cornerRadius)) / 2.0
        
        // Start drawing at a point, which by default is at the right hand edge
        // but can be offset
        var angle = CGFloat(rotationOffset)
        
        let corner = CGPoint(x: center.x + (radius - cornerRadius) * cos(angle), y: center.y + (radius - cornerRadius) * sin(angle))
        path.move(to: CGPoint(x: corner.x + cornerRadius * cos(angle + theta), y: corner.y + cornerRadius * sin(angle + theta)))
        
        for _ in 0 ..< sides {
            angle += theta
            
            let corner = CGPoint(x: center.x + (radius - cornerRadius) * cos(angle), y: center.y + (radius - cornerRadius) * sin(angle))
            let tip = CGPoint(x: center.x + radius * cos(angle), y: center.y + radius * sin(angle))
            let start = CGPoint(x: corner.x + cornerRadius * cos(angle - theta), y: corner.y + cornerRadius * sin(angle - theta))
            let end = CGPoint(x: corner.x + cornerRadius * cos(angle + theta), y: corner.y + cornerRadius * sin(angle + theta))
            
            path.addLine(to: start)
            path.addQuadCurve(to: end, controlPoint: tip)
        }
        path.close()
        
        // Move the path to the correct origins
        let bounds = path.bounds
        let transform = CGAffineTransform(translationX: -bounds.origin.x + rect.origin.x + lineWidth / 2.0,
                                          y: -bounds.origin.y + rect.origin.y + lineWidth / 2.0)
        path.apply(transform)
        return path
}

func getDateFromTimestamp(_ timestamp: Double) -> String {
    
    let current = Date()
    let objDateFormatter = DateFormatter()
    objDateFormatter.dateFormat = "YYYY"
    //  let currentYear: String = objDateFormatter.string(from: current)
    //let date = Date(timeIntervalSince1970: timestamp / 1000)  // /1000
    let date = Date(timeIntervalSince1970: timestamp)
    let dateFormatter = DateFormatter()
    let dateFormatter1 = DateFormatter()
    dateFormatter1.dateFormat = "YYYY"
    // let year: String = dateFormatter1.string(from: date)
    dateFormatter.dateFormat = "MMM"
    var dateString1: String = dateFormatter.string(from: date)
    dateString1 = "\(dateString1)"
    
    let distanceBetweenDates: TimeInterval = current.timeIntervalSince(date)
    let min: Int = Int(distanceBetweenDates) / 60
    let gregorianCalendar = Calendar(identifier: .gregorian)
    //            var components: DateComponents? = gregorianCalendar.dateComponents(.day, from: date, to: current, options:.wrapComponents)
    let components = gregorianCalendar.dateComponents([.day], from: date, to: current)
    //   var components: DateComponents? = (gregorianCalendar as NSCalendar).components(.day, from: date)
    
    let noOfDay: Int? = components.day
    
    if min <= 59 {
        if min < 1 {
            return "Just Now"
        }
        else if min == 1 {
            return "\(min) min ago"
        }
        else {
            return "\(min) mins ago"
        }
    }
    else if (min / 60) <= 23 {
        if (min / 60) == 1 {
            return "\(min / 60) hr ago"
        }
        else {
            return "\(min / 60) hrs ago"
        }
    }
    else if noOfDay! < 31 {
        if noOfDay! <= 1 {
            return "\(noOfDay!) day ago"
        }
        else {
            return "\(noOfDay!) days ago"
        }
    }
    else if noOfDay! < 365{
        let noOfMonth : Int = noOfDay! / 30
        if noOfMonth <= 1 {
            return "\(noOfMonth) month ago"
        }
        else {
            return "\(noOfMonth) months ago"
        }
    }
    else {
        let noOfYear : Int = noOfDay! / 365
        if noOfYear <= 1 {
            return "\(noOfYear) year ago"
        }else{
            return "\(noOfYear) years ago"
        }
        //                    if (year == currentYear) {
        //                        return "\(dateString1)"
        //                    }
        //                    else {
        //                      return "\(dateString1), \(year)"
        //                    }
    }
}

func getDateFormTimeStamp(fromTimestamp timestamp: Double) -> String {
    let date = Date(timeIntervalSince1970: timestamp)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MMM yyyy"
    let dateString: String = dateFormatter.string(from: date)
    return dateString
}

func getDateFormTimeStampNew(fromTimestamp timestamp: Double) -> Date {
    let date = Date(timeIntervalSince1970: timestamp)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yyyy"
    return date
}

func getDateFormDifferentTimeStamp(fromTimestamp timestamp: Double) -> String {
    let date = Date(timeIntervalSince1970: timestamp)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd/MM/yy"
    let dateString: String = dateFormatter.string(from: date)
    return dateString
}


extension UIImage {
    
    func convertToBase64String() -> String {
        var str = ""
        if let data = UIImagePNGRepresentation(self) {
            str = data.base64EncodedString()
        }
        return str
    }
}


extension String {
    
    func isValidNumber() -> Bool    {
        
        let nameRegEx = "^[0-9]+$"
        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return nameTest.evaluate(with: self)
    }
    
    func validate() -> Bool {
        let PHONE_REGEX = self.contains("+") ?  "^((\\+)|(00))[0-9]{6,14}$" : "^[0-9]+$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: self)
        return result
    }
    
    func isValidUserName() -> Bool {
        let nameRegEx = "^[a-zA-Z0-9._]+$"
        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return nameTest.evaluate(with: self)
    }
    
    func isValidDate(dateString: String) -> Bool {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "dd/MM/yyyy"
        if let _ = dateFormatterGet.date(from: dateString) {
            return true
        } else {
            return false
        }
    }
    
    func getStringFromDate(date : Date) -> String {
        let dateFormat = DateFormatter.init()
        dateFormat.timeZone = NSTimeZone.local
        dateFormat.dateFormat = "dd-MM-YYYY"
        return dateFormat.string(from: date)
    }
    
    func isPostalCode() -> Bool {
        
        let postalCodeRegex = "^[0-9]+$"
        let postalCodeTest = NSPredicate(format:"SELF MATCHES %@", postalCodeRegex)
        return postalCodeTest.evaluate(with: self)
    }
    
    func containsNumberOnly() -> Bool {
        let nameRegEx = "^[0-9]+$"
        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return nameTest.evaluate(with: self)
    }
    
    
    func isContainsAllZeros() -> Bool {
        let mobileNoRegEx = "^0*$";
        let mobileNoTest = NSPredicate(format:"SELF MATCHES %@", mobileNoRegEx)
        return mobileNoTest.evaluate(with: self)
    }
    
    //Function For accepting atleast one special character and One Number
    func isContainsAtleastOneSpecialCharactersAndOneNumber() -> Bool{
        let passwordRegEx = "^(?=.*?[$@$!%*#?&^)(]).{8,}+[0-9]$"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: self)
    }
    
    
    //
}

class AppUtility: NSObject {
    
    class func deviceUDID() -> String {
        
        var udidString = ""
        
        if let udid = UIDevice.current.identifierForVendor?.uuidString {
            udidString = udid
        }
        
        return udidString
    }
    
    // Date from unix timestamp from Date
    class func date(timestamp: Double) -> Date {
        return Date(timeIntervalSince1970: timestamp)
    }
    
    class func getStoryBoard(storyBoardName: String) -> UIStoryboard {
        return  UIStoryboard(name: storyBoardName, bundle:nil)
    }
    
    class func addSubview(subView: UIView, toView parentView: UIView) {
        parentView.addSubview(subView)
        
        var viewBindingsDict = [String: AnyObject]()
        viewBindingsDict["subView"] = subView
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[subView]|",
                                                                 options: [], metrics: nil, views: viewBindingsDict))
        parentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[subView]|",
                                                                 options: [], metrics: nil, views: viewBindingsDict))
    }
    
    class func leftBarButton(_ imageName : String, controller : UIViewController) -> UIBarButtonItem {
        let button:UIButton = UIButton.init(type: UIButtonType.custom)
        button.frame = CGRect(x: 10, y: 0, width: 40, height: 40)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.setImage(UIImage(named: imageName as String), for: UIControlState())
        button.addTarget(controller, action:#selector(leftBarButtonAction(_:)), for: UIControlEvents.touchUpInside)
        let leftBarButtonItem:UIBarButtonItem = UIBarButtonItem(customView: button)
        NSLayoutConstraint.activate([(leftBarButtonItem.customView!.widthAnchor.constraint(equalToConstant: 40)),(leftBarButtonItem.customView!.heightAnchor.constraint(equalToConstant: 40))])

        return leftBarButtonItem
    }
    
    class func rightBarButton(_ imageName : String, controller : UIViewController) -> UIBarButtonItem {
        let button:UIButton = UIButton.init(type: UIButtonType.custom)
        button.frame = CGRect(x: 10, y: 0, width: 40, height: 40)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.setImage(UIImage(named: imageName as String), for: UIControlState())
        button.addTarget(controller, action:#selector(rightBarButtonAction(_:)), for: UIControlEvents.touchUpInside)
        let rightBarButtonItem:UIBarButtonItem = UIBarButtonItem(customView: button)
        NSLayoutConstraint.activate([(rightBarButtonItem.customView!.widthAnchor.constraint(equalToConstant: 40)),(rightBarButtonItem.customView!.heightAnchor.constraint(equalToConstant: 40))])

        return rightBarButtonItem
    }
    
    class func leftTitleBarButton(_ title : String, controller : UIViewController) -> UIBarButtonItem {
        let button:UIButton = UIButton.init(type: UIButtonType.custom)
        button.frame = CGRect(x: 10, y: 10, width: 40, height: 20)
        button.setTitle(title, for: UIControlState())
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = setArialRegularFont(size: 14)
        button.addTarget(controller, action:#selector(leftBarButtonAction(_:)), for: UIControlEvents.touchUpInside)
        let leftBarButtonItem:UIBarButtonItem = UIBarButtonItem(customView: button)
        return leftBarButtonItem
    }
    
    class func rightTitleBarButton(_ title : String, controller : UIViewController) -> UIBarButtonItem {
        let button:UIButton = UIButton.init(type: UIButtonType.custom)
        button.frame = CGRect(x: 10, y: 10, width: 40, height: 20)
        button.setTitle(title, for: UIControlState())
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = setArialRegularFont(size: 14)
        button.addTarget(controller, action:#selector(rightBarButtonAction(_:)), for: UIControlEvents.touchUpInside)
        let rightBarButtonItem:UIBarButtonItem = UIBarButtonItem(customView: button)
        return rightBarButtonItem
    }
    
    // MARK: - Selector Methods
    @objc func leftBarButtonAction(_ sender : UIButton) {
    }
    
    @objc func rightBarButtonAction(_ sender : UIButton) {
    }
    
    class func gotoHomeController() {
        
        let sideMenuController = APPDELEGATE.sideMenuController
        guard let centeralNavController = sideMenuController.centerViewController as? UINavigationController else {
        return
        }
        centeralNavController.popToRootViewController(animated: false)
        let tabBarVC = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        centeralNavController.setViewControllers([tabBarVC], animated: false)
        sideMenuController.closeSlider(.left, animated: true) { (_) in
        //do nothing
        }
        
    }
    
    class func gotoLocationController() {
        
        let sideMenuController = APPDELEGATE.sideMenuController
        guard let centeralNavController = sideMenuController.centerViewController as? UINavigationController else {
            return
        }
        centeralNavController.popToRootViewController(animated: false)
        
//        if let tabBarController = UIWindow?.rootViewController as? UITabBarController {
//            tabBarController.selectedIndex = 1
//        }
        
        let tabBarVC = mainStoryboard.instantiateViewController(withIdentifier: "TabBarViewControllerID") as! TabBarViewController
        tabBarVC.selectedIndex = 2
        
        centeralNavController.setViewControllers([tabBarVC], animated: false)
        sideMenuController.closeSlider(.left, animated: true) { (_) in
            //do nothing
        }
        
    }

}

