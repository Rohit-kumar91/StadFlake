//
//  AppDelegate.swift
//  Stadtfalke
//
//  Created by Manoj Kumar Singh on 12/06/18.
//  Copyright © 2018 Manoj Kumar Singh. All rights reserved.
//

import UIKit
import LGSideMenuController
import SystemConfiguration
import CoreLocation
import GoogleMaps
import ZoomableImageSlider
import UserNotifications
import Firebase
import SwiftyJSON
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var navigationController = UINavigationController()
    var privateSideMenuController: MASliderViewController?
    var locationManager: CLLocationManager!
    var firebaseInstanceId = String()
    var gcmMessageIDKey = "gcm_message_id"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        GMSServices.provideAPIKey("AIzaSyCO0KnlaYUxUoKz2bUIJT7H2m4XL_nILkY")
        
        self.registerForRemoteNotification(application)
        Messaging.messaging().delegate = self
        FirebaseApp.configure()
        Fabric.with([Crashlytics.self])
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                if #available(iOS 10, *) {
                    self.addRegisterDevice(result.token)
                } else {
                    // Fallback on earlier versions
                }
                
            }
        }
        
        
        USERDEFAULT.setValue("0", forKey: "value")
        USERDEFAULT.synchronize()
        loginController()
        
        UserDefaults.standard.set("", forKey: "status")
        UserDefaults.standard.set("", forKey: "category")
        UserDefaults.standard.set("", forKey: "distance")
        UserDefaults.standard.synchronize()

        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        NotificationCenter.default.addObserver(self, selector: #selector(self.yourfunction2(notfication:)), name: NSNotification.Name(rawValue: "presentImageView"), object: nil)
        
        
        
        //Navigate to the home screen
        if let saveSlug = UserDefaults.standard.value(forKey: "saveSlug") {
            APPDELEGATE.window = UIWindow.init(frame: UIScreen.main.bounds)
            APPDELEGATE.navigationController.navigationBar.isHidden = true
            APPDELEGATE.window?.rootViewController = APPDELEGATE.sideMenuController
            APPDELEGATE.window?.makeKeyAndVisible()
            Singleton.instance.citySlug = saveSlug as! String
        }

        return true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        let location = locations.last! as CLLocation
        let lat = location.coordinate.latitude
        let long = location.coordinate.longitude
        UserDefaults.standard.set(lat, forKey: "lat")
        UserDefaults.standard.set(long, forKey: "long")
        UserDefaults.standard.synchronize()
        
        myCurrentLat = lat
        myCurrentLong = long

    }
    
    func setNavigationController(navigation:UINavigationController) {
        navigation.navigationBar.isTranslucent = false
        navigation.interactivePopGestureRecognizer?.isEnabled = false
        navigation.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: KAppNavigationTitleFont as Any]
        navigation.navigationBar.backgroundColor = kAppBackgroundColor
        navigation.navigationBar.barTintColor = kAppBackgroundColor
        navigation.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigation.navigationBar.shadowImage = UIImage()

        UIApplication.shared.statusBarStyle = .lightContent
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //MARK: - ProgressIndicator view start
//    func startProgressView(view:UIView){
//        let spinnerActivity = MBProgressHUD.showAdded(to: view, animated: true)
//        // spinnerActivity.backgroundColor = UIColor.clear
//        spinnerActivity.bezelView.color = UIColor.clear
//        spinnerActivity.mode = MBProgressHUDMode.indeterminate
//        spinnerActivity.animationType = .zoomOut
//
//    }
//
//    //MARK: - ProgressIndicator View Stop
//    func dismissProgressView(view:UIView)  {
//        MBProgressHUD.hide(for: view, animated: true)
//    }
    
    //Mark :- To Check Reachability
    func checkReachablility() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    @objc func yourfunction2(notfication: NSNotification) {
        
        let arrPageImage = notfication.userInfo?.validatedValue("imageList", expected: [] as AnyObject) as! [String]
        let vc = ZoomableImageSlider(images: arrPageImage , currentIndex: nil, placeHolderImage: UIImage.init(named: "Placeholder"))
        self.window?.rootViewController?.present(vc, animated: true, completion: nil)
       // UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
        //  self.present(vc, animated: true, completion: nil)
        
    }
    
    //MARK:- Push Notification Delegate Methods
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
//        let tokenParts = deviceToken.map { data -> String in
//            return String(format: "%02.2hhx", data)
//        }
//        let token = tokenParts.joined()
//        firebaseInstanceId = token
//
//        UserDefaults.standard.set(token, forKey: "DeviceToken")
//        print("Device Token: \(token)")
//
//        if let refreshedToken = InstanceID.instanceID().token() {
//            print("InstanceID token: \(refreshedToken)")
//            self.firebaseInstanceId = refreshedToken
//        }
        
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instange ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                self.firebaseInstanceId = result.token
            }
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        UserDefaults.standard.set("jdshkfhsdkjfsdkjf", forKey: "DeviceToken")
        UserDefaults.standard.synchronize()
    }
    
    //MARK:- Register For Push Notification
    fileprivate func registerForRemoteNotification(_ application: UIApplication) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                guard error == nil else {
                    return
                }
                if granted {
                    DispatchQueue.main.async {
                        application.registerForRemoteNotifications()
                    }
                } else {
                    //Handle user denying permissions..
                    self.registerForRemoteNotification(application)
                }
            }
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        DispatchQueue.main.async {
            application.registerForRemoteNotifications()
        }
    }


}

extension AppDelegate : MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
      
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
}

extension AppDelegate {
    
    func loginController(){
        
        if (USERDEFAULT.value(forKey: "isFirstTime") != nil) {
            window = UIWindow.init(frame: UIScreen.main.bounds)
            self.navigationController = UINavigationController.init(rootViewController: sideMenuController)
            self.navigationController.navigationBar.isHidden = true
            window?.rootViewController = sideMenuController// self.navigationController
            window?.makeKeyAndVisible()
        }else {
            
            let deinStadtfalkeVC = mainStoryboard.instantiateViewController(withIdentifier: "DeineStadtViewController") as! DeineStadtViewController
            window = UIWindow.init(frame: UIScreen.main.bounds)
            self.navigationController = UINavigationController.init(rootViewController: deinStadtfalkeVC)
            self.navigationController.navigationBar.isHidden = true

            window?.rootViewController = deinStadtfalkeVC //self.navigationController
            window?.makeKeyAndVisible()
        }
    }

    var sideMenuController: MASliderViewController {

        let mainStoryboard = UIStoryboard.init(name: "Main", bundle: nil)

        if let privateSideMenuController = privateSideMenuController {
            navigationController.navigationBar.isHidden = true
            return privateSideMenuController
        }
        self.navigationController.navigationBar.isHidden = true
        let mainViewController = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        let drawerViewController = mainStoryboard.instantiateViewController(withIdentifier: "MenuViewControllerID") as! MenuViewController
        let centerNavController = UINavigationController.init(rootViewController: mainViewController)
        privateSideMenuController?.navigationController?.navigationBar.isHidden = true;
        let sliderViewController = MASliderViewController()
        self.setNavigationController(navigation: centerNavController)
        sliderViewController.leftViewController = drawerViewController
        sliderViewController.centerViewController = centerNavController
        sliderViewController.leftDrawerWidth = kWindowWidth - 60
        privateSideMenuController = sliderViewController
        
        return privateSideMenuController!
    }
    
    
    
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

@available(iOS 10, *)
extension AppDelegate  {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
                // Print message ID.
                if let messageID = userInfo[gcmMessageIDKey] {
                    print("Message ID: \(messageID)")
                }
        
        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([.alert])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        //
        // Print full message.
        print(userInfo)
        
        completionHandler()
    }
    
    
    func addRegisterDevice(_ token: String) {
        
        print(token)
        
        UserDefaults.standard.set(deviceUDID(), forKey: "current_UDID")
        
        let param = [
            "token" : token,
            "udid" : deviceUDID(),
            "type" : "I"
        ]
        
        print(param)
        
        ServiceHelper.sharedInstance.createPostRequest(isShowHud: true, params: param as [String : AnyObject], apiName: "api/device/add") { (response, error) in
            
            if error != nil {
                
                MCCustomAlertController.alert(title: "", message: (error?.localizedDescription)!, buttons: ["OK"], tapBlock: { (action, index) in
                    //
                })
                return
            }
            
            if (response != nil) {
                //   self.listOfWeek = response?.object(forKey:"data") as! [Dictionary<String, Any>]
                let JSONResponse = JSON(response as Any)
                let cititesData = JSONResponse["data"]["cities"].arrayValue
                
                print("Citestse",cititesData)
                
                
                Singleton.instance.citiesArray = cititesData
                
                
            } else {
                
                
                MCCustomAlertController.alert(title: "", message: "Something went wrong.", buttons: ["OK"], tapBlock: { (action, index) in
                    //
                })
                return
            }
        }
    }
    
    
    func deviceUDID() -> String {
        var udidString = ""
        if let udid = UIDevice.current.identifierForVendor?.uuidString {
            udidString = udid
        }
        return udidString
    }
}

