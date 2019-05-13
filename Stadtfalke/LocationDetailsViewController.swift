//
//  LocationDetailsViewController.swift
//  Stadtfalke
//
//  Created by Manoj Kumar Singh on 19/06/18.
//  Copyright © 2018 Manoj Kumar Singh. All rights reserved.
//

import UIKit
import ZoomableImageSlider
import SwiftyJSON

class LocationDetailsViewController: UIViewController {

    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationTableView: UITableView!
    @IBOutlet weak var pageController: UIPageControl!
    var selectedDict = JSON()
    var timer = Timer()
    var pageIndex : Int = 0
    var arrPageImage = [JSON]()
    var locationID : String!
    var lattitude : Double = 0.0
    var longitude : Double = 0.0
    
    var dataArray = [Dictionary<String, AnyObject>]()
    var refreshControl = UIRefreshControl()
    var responseLocationData = JSON()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        callAPITOGetLocationDetail()
        
        // Do any additional setup after loading the view.
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(sender:)), for: .valueChanged)
        locationTableView.addSubview(refreshControl)
        
    }
    
    @objc func refresh(sender:AnyObject) {
        // Code to refresh table view
        self.callAPITOGetLocationDetail()
        refreshControl.endRefreshing()
    }
    func initialSetup(){
        
        
        arrPageImage = selectedDict["galleries"].arrayValue
        let temp = selectedDict["get_location_hours"].arrayValue
        Singleton.instance.location_Id = temp[0]["location_id"].stringValue
        
        if arrPageImage.count >= 1{
            self.bannerImageView.sd_setImage(with: URL.init(string: baseURL + arrPageImage[0]["media_images"]["path"].stringValue  + "/" + arrPageImage[0]["media_images"]["name"].stringValue), placeholderImage:UIImage.init(named: "Placeholder"), options: .lowPriority, completed: nil)
        }
        
        //        self.iconImageView.sd_setImage(with: URL.init(string: "http://testing.net.in/stadtfalke_31072018/\(selectedDict.validatedValue("image", expected: "" as AnyObject) as! String)"), placeholderImage:UIImage.init(named: "Placeholder"), options: .lowPriority, completed: nil)
        
        pageController.numberOfPages = arrPageImage.count
        nameLabel.text = self.selectedDict["name"].stringValue
       
    
        iconImageView.sd_setImage(with: URL.init(string: baseURL + selectedDict["logo_media_image"]["path"].stringValue  + "/" +  selectedDict["logo_media_image"]["name"].stringValue), placeholderImage: #imageLiteral(resourceName: "Placeholder"), options: .continueInBackground, completed: nil)
        
        //swipe gesture
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        bannerImageView.isUserInteractionEnabled = true
        bannerImageView.addGestureRecognizer(tapGestureRecognizer)
        
        //set timer
        self.startTimer()
    }
    
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        var tempImages = [String]()
        
        print("Array page Images ", arrPageImage)
        
        for value in arrPageImage {
            
            print("VAlue", value)
            
            tempImages.append( baseURL + value["media_images"]["path"].stringValue  + "/" + value["media_images"]["name"].stringValue)
            
             print(baseURL + value["media_images"]["path"].stringValue  + "/" + value["media_images"]["name"].stringValue)
            
            
        }
        
       
        
        let vc = ZoomableImageSlider(images: tempImages, currentIndex: nil, placeHolderImage: UIImage.init(named: "Placeholder"))
        self.navigationController?.pushViewController(vc, animated: true)
     
    }
    
    @IBAction func specialbtnACTION(_ sender: UIButton) {
        
        USERDEFAULT.setValue("\(sender.tag)", forKey: "value")
        USERDEFAULT.synchronize()
        
        AppUtility.gotoHomeController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startTimer() {
        self.timer = Timer .scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(loadNextImage), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        if (self.timer.isValid) {
            self.timer.invalidate();
        }
    }
    
    func open(gestur: UITapGestureRecognizer){
        
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        self.stopTimer()
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
                
                self.pageIndex = (pageIndex != 0) ? self.pageIndex - 1 : arrPageImage.count - 1
                self.pageController.currentPage = self.pageIndex
                let transition = CATransition()
                transition.duration = 0.5
                transition.type = kCATransitionPush
                transition.subtype = kCATransitionFromLeft
                transition.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
                self.bannerImageView.layer.add(transition, forKey:"SwitchToView")
                
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
                
                self.pageIndex = (pageIndex != self.arrPageImage.count-1) ? self.pageIndex + 1 : 0
                self.pageController.currentPage = self.pageIndex
                let transition = CATransition()
                transition.duration = 0.5
                transition.type = kCATransitionPush
                transition.subtype = kCATransitionFromRight
                transition.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
                self.bannerImageView.layer.add(transition, forKey:"SwitchToView")
                
            default:
                break
            }
            
            
            print(baseURL + arrPageImage[pageIndex]["media_images"]["path"].stringValue)
            
            self.bannerImageView.sd_setImage(with: URL.init(string: baseURL + arrPageImage[pageIndex]["media_images"]["path"].stringValue + "/" +
                arrPageImage[pageIndex]["media_images"]["name"].stringValue), placeholderImage:UIImage.init(named: "Placeholder"), options: .lowPriority, completed: nil)
        }
        self.startTimer()
    }
    
    @objc func loadNextImage() {
        
        if arrPageImage.count == 0 {
            return
        }
     
        
        self.pageIndex = (pageIndex != self.arrPageImage.count-1) ? self.pageIndex + 1 : 0
        self.pageController.currentPage = self.pageIndex
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        transition.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
        self.bannerImageView.layer.add(transition, forKey:"SwitchToView")
        //self.bannerImageView.image = UIImage.init(named: arrPageImage[pageIndex] as! String)
        
        let urlString = baseURL + arrPageImage[pageIndex]["media_images"]["path"].stringValue  + "/" + arrPageImage[pageIndex]["media_images"]["name"].stringValue
        
        self.bannerImageView.sd_setImage(with: URL.init(string:urlString ), placeholderImage:UIImage.init(named: "Placeholder"), options: .lowPriority, completed: nil)
        
    }

    // MARK:- IBAction methods
    @IBAction func menuButtonAction(_ sender: UIButton) {
    
        Singleton.instance.location_Id = ""
        self.navigationController?.popViewController(animated: true)
        //self.toggleSlider()
    }

    @IBAction func notificationButtonAction(_ sender: UIButton) {
        let sideMenuController = APPDELEGATE.sideMenuController
        guard let centeralNavController = sideMenuController.centerViewController as? UINavigationController else {
            return
        }
        centeralNavController.popToRootViewController(animated: false)
        
        let mitteilungenVC = self.storyboard?.instantiateViewController(withIdentifier: "MitteilungenViewControllerID") as! MitteilungenViewController
        centeralNavController.setViewControllers([mitteilungenVC], animated: false)
        sideMenuController.closeSlider(.left, animated: true) { (_) in
            //do nothing
        }
    }
    
    private func callAPITOGetLocationDetail() {
        var dicParams = [String: String]()
        
        print(Singleton.instance.detailLocationID)
        
        if Singleton.instance.detailLocationID != "" {
            
            dicParams = [
                "location_slug" : Singleton.instance.detailLocationID
            ]
            
            Singleton.instance.detailLocationID = ""
            
        } else {
            dicParams = [
                "location_slug" :  locationID
            ]
        }
        
     
        
        
        print(dicParams)

        ServiceHelper.sharedInstance.createEncodedPostRequest(isShowHud: true, params: dicParams as [String : AnyObject], apiName: "api/locationDetail") { (response, error) in
            
           
            self.responseLocationData = JSON(response as Any)
            if error != nil {
                MCCustomAlertController.alert(title: "", message: (error?.localizedDescription)!, buttons: ["OK"], tapBlock: { (action, index) in
                })
                return
            }
            
            
            if (self.responseLocationData["data"].dictionary != nil) {
                
                let status = self.responseLocationData["status"].stringValue
                if status == "true" {
                  
                        self.selectedDict = self.responseLocationData["data"]
                        self.initialSetup()
                        self.dataArray = [["Image":"clock","Name":"Es ist Montag 14:05 | wir haben geoffnet"],["Image":"clock1","Name":"Du bist 2.83 km entfernt. Jetzt routen"],["Image":"barjpg","Name":"Specials"],["Image":"user","Name":"Uber uns & Kontaktdaten"],["Image":"pdf","Name":"Menü"]] as [Dictionary<String, AnyObject>]
                        self.locationTableView.reloadData()
                    
                    
                }else{
                    // MCCustomAlertController.alert(title: "", message: "Invalid credential.")
                }
                
            } else {
                MCCustomAlertController.alert(title: "", message: "Something went wrong.", buttons: ["OK"], tapBlock: { (action, index) in
                    //
                })
                return
            }
        }
    }
}

extension LocationDetailsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationDetailsTableViewCellID") as! LocationDetailsTableViewCell
    
        if (indexPath.row == 0) {
            
            let blackText = "Es ist Samstag " + "\(Date().getDateString()) wir haben"
            let attrs = [NSAttributedStringKey.foregroundColor : UIColor.black]
            let attributedString = NSMutableAttributedString(string: blackText, attributes: attrs)
            
//            let yelloText = "\(selectedDict["open_cl"].stringValue == "on" ? " geöffnet" : " geschlossen")"
//            let yAttrs = [NSAttributedStringKey.foregroundColor : UIColor(red: 255/255, green: 194/255, blue: 0/255, alpha: 1.0)]
//            let yAttributedString = NSMutableAttributedString(string: yelloText, attributes: yAttrs)
//            attributedString.append(yAttributedString)
            
            cell.categoryTitleLabel.attributedText = attributedString
            cell.iconImageView.image = #imageLiteral(resourceName: "clock-1")
            
        } else if (indexPath.row == 1) {
            let blackText = "Du bist \(selectedDict["distance"].stringValue) entfernt."
            let attrs = [NSAttributedStringKey.foregroundColor : UIColor.black]
            let attributedString = NSMutableAttributedString(string: blackText, attributes: attrs)
            
//            let yelloText = " Jetzt routen"
//            let yAttrs = [NSAttributedStringKey.foregroundColor : UIColor(red: 255/255, green: 194/255, blue: 0/255, alpha: 1.0)]
//            let yAttributedString = NSMutableAttributedString(string: yelloText, attributes: yAttrs)
//            attributedString.append(yAttributedString)
            
            cell.categoryTitleLabel.attributedText = attributedString
            cell.iconImageView.image = #imageLiteral(resourceName: "compass")
            
        } else if indexPath.row == 2 {
             cell.categoryTitleLabel.text = "Specials"
             cell.iconImageView.image = #imageLiteral(resourceName: "plate-with-fork-and-knife-eating-set-tools-from-top-view")
        } else if indexPath.row == 3 {
            
            cell.categoryTitleLabel.text = "Über uns und Kontaktdaten"
            cell.iconImageView.image = #imageLiteral(resourceName: "business-card-of-a-man-with-contact-info")
            
        } else if indexPath.row == 4 {
            
            cell.iconImageView.image = #imageLiteral(resourceName: "bar")
            cell.categoryTitleLabel.text =  "Menu"
        }
       
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        switch indexPath.row {
        case 0:
            
            let offnunVC = mainStoryboard.instantiateViewController(withIdentifier: "OffnungszitenViewController") as! OffnungszitenViewController
            
            
            print(selectedDict)
            
            
            offnunVC.menuTimeArray = selectedDict["get_location_hours"].arrayValue
            
            self.navigationController?.pushViewController(offnunVC, animated: true)
            break
        case 1:
            
            if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(URL(string:"comgooglemaps://?saddr=&daddr=\(lattitude),\(longitude)&directionsmode=driving")!, options: [:], completionHandler: nil)
                } else {
                    // Fallback on earlier versions
                    let lat = lattitude
                    let longi = longitude
                    
                    if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(lat),\(longi)&directionsmode=driving") {
                        UIApplication.shared.openURL(urlDestination)
                    }
                }
            } else {
                let lat = lattitude
                let longi = longitude
                
                if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(lat),\(longi)&directionsmode=driving") {
                    UIApplication.shared.openURL(urlDestination)
                }
            }
        
            break
        case 2:

            AppUtility.gotoHomeController()
            
            break
        case 3:
            let aboutUsVC = mainStoryboard.instantiateViewController(withIdentifier: "AboutUsViewControllerID") as! AboutUsViewController
           
            print(selectedDict)
           
            aboutUsVC.dictValue = selectedDict
            //aboutUsVC.locationID = self.selectedDict.validatedValue("id", expected: "" as AnyObject) as! String
            self.navigationController?.pushViewController(aboutUsVC, animated: true)
            break
        case 4:
            
            let array = selectedDict["menus"].arrayValue
            
            if array.count == 0 {
               
                MCCustomAlertController.alert(title: "", message: "File not available.", buttons: ["OK"], tapBlock: { (action, index) in
                })
                
            } else {
                let locationsVC = mainStoryboard.instantiateViewController(withIdentifier: "MenuTimeViewController") as! MenuTimeViewController                
                locationsVC.menuData = array
                self.navigationController?.pushViewController(locationsVC, animated: true)
            }
            
           
            break
        default:
            break
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Alert", message: "Work in progress", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension Date {
    
    func getDateString() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        
        return dateFormatter.string(from: self)
    }
    
}


extension UINavigationController {
    
    func backViewController(viewController: Swift.AnyClass) {
        
        for element in viewControllers as Array {
            if element.isKind(of: viewController) {
                self.popToViewController(element, animated: true)
                break
            }
        }
    }
}


