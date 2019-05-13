//
//  HomeViewController.swift
//  Stadtfalke
//
//  Created by Ashish Kr Singh on 08/07/18.
//  Copyright © 2018 Manoj Kumar Singh. All rights reserved.
//

import UIKit
import ZoomableImageSlider

class HomeViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var thirdBtn: UIButton!
    @IBOutlet weak var locationBtn: UIButton!
    @IBOutlet weak var specialBtn: UIButton!
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!

    @IBOutlet weak var thirdLabel: UILabel!

    @IBOutlet weak var topConstant: NSLayoutConstraint!
    //controller
    var specialVC:SpecialViewController = SpecialViewController()
    var locationVC:LocationsViewController = LocationsViewController()
    var thirdVC:YourCityViewController = YourCityViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        initialMethods()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.yourfunction(notfication:)), name: NSNotification.Name(rawValue: "goToDetails"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.yourfunction1(notfication:)), name: NSNotification.Name(rawValue: "goToLocationDetails"), object: nil)
        
        // Register to receive notification in your class
        NotificationCenter.default.addObserver(self, selector: #selector(self.showSpinningWheel(_:)), name: NSNotification.Name(rawValue: "detailsLocation"), object: nil)

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    // handle notification
    @objc func showSpinningWheel(_ notification: NSNotification) {
        print(notification.userInfo ?? "")
        
        let locationsDetailsVC = mainStoryboard.instantiateViewController(withIdentifier: "LocationDetailsViewControllerID") as! LocationDetailsViewController
        
        if let dict = notification.userInfo as NSDictionary? {
            
            print(dict.value(forKey: "id") as! String)
            print(dict.value(forKey: "lat") as! String)
             print(dict.value(forKey: "longi") as! String)
        
            if let latitude = dict["lat"] as? String {
                // do something with your image
                
                locationsDetailsVC.lattitude = Double(latitude) ?? 0.0
            }
            
            
            if let longitude = dict["longi"] as? String {
                // do something with your image
                locationsDetailsVC.longitude = Double(longitude) ?? 0.0
            }
            
            
            if let slug = dict["id"] as? String{
                // do something with your image
                print(slug)
                Singleton.instance.detailLocationID = slug
                print(Singleton.instance.detailLocationID)
                locationsDetailsVC.locationID = slug
            }
           
            
            
        }
        
//        let latitude = locationData[indexPath.row]["location_info"]["latitude"].doubleValue
//        let longitude = locationData[indexPath.row]["location_info"]["longitude"].doubleValue
//        locationsDetailsVC.lattitude = latitude
//        locationsDetailsVC.longitude = longitude
//        locationsDetailsVC.locationID = locationData[indexPath.row]["location_info"]["slug"].stringValue
        self.navigationController?.pushViewController(locationsDetailsVC, animated: true)
        
    }
    
   
    
    
    
    @objc func yourfunction1(notfication: NSNotification) {
        
        let id = notfication.userInfo?.validatedValue("id", expected: "" as AnyObject) as! String
        let locationsDetailsVC = mainStoryboard.instantiateViewController(withIdentifier: "LocationDetailsViewControllerID") as! LocationDetailsViewController
        locationsDetailsVC.locationID = id
        self.navigationController?.pushViewController(locationsDetailsVC, animated: true)
        
    }
    
    @objc func yourfunction(notfication: NSNotification) {
        
        let id = notfication.userInfo?.validatedValue("id", expected: "" as AnyObject) as! String
        let locationsDetailsVC = mainStoryboard.instantiateViewController(withIdentifier: "ProgramDetailViewController") as! ProgramDetailViewController
        locationsDetailsVC.offerID = id
        self.navigationController?.pushViewController(locationsDetailsVC, animated: true)
    
    }
    
    
    //MARK - Initial Methods
    func initialMethods() {
       // self.topConstant.constant = self.topConstant.constant + 20
     //   self.view.setNeedsLayout()
        specialVC = mainStoryboard.instantiateViewController(withIdentifier: "SpecialViewControllerID") as! SpecialViewController
        locationVC = mainStoryboard.instantiateViewController(withIdentifier: "LocationsViewControllerID") as! LocationsViewController
        thirdVC = mainStoryboard.instantiateViewController(withIdentifier: "YourCityViewControllerID") as! YourCityViewController
        
        thirdVC.view.removeFromSuperview()
        specialVC.view.removeFromSuperview()
        locationVC.view.frame = self.containerView.frame;
        self.containerView.addSubview(locationVC.view)
        
        if USERDEFAULT.string(forKey: "value") == "2"{
            setController(index: 2)
        }else if USERDEFAULT.string(forKey: "value") == "1"{
            setController(index: 1)
        }else{
            setController(index: 0)
        }
       self.view.setNeedsLayout()
    }
    
    func setController(index : Int){
        
        specialBtn.isSelected = false
        firstLabel.textColor = UIColor.black
        locationBtn.isSelected = false
        secondLabel.textColor = UIColor.black
        thirdBtn.isSelected = false
        thirdLabel.textColor = UIColor.black
        
        
        if index == 0 {
            //special controller
            specialBtn.isSelected = true
            firstLabel.textColor = UIColor.init(red: (255.0/255.0), green: (194/255.0), blue: (0/255.0), alpha: 1.0)
            
            thirdVC.view.removeFromSuperview()
            locationVC.view.removeFromSuperview()
            specialVC.view.frame = self.containerView.frame;
            self.containerView.addSubview(specialVC.view)
           
        
        }else if index == 1{
            //location controller
            locationBtn.isSelected = true
            secondLabel.textColor = UIColor.init(red: (255.0/255.0), green: (194/255.0), blue: (0/255.0), alpha: 1.0)
            thirdVC.view.removeFromSuperview()
            specialVC.view.removeFromSuperview()
            locationVC.view.frame = self.containerView.frame;
            self.containerView.addSubview(locationVC.view)
            
        }else{
            //third controller
            thirdBtn.isSelected = true
            thirdLabel.textColor = UIColor.init(red: (255.0/255.0), green: (194/255.0), blue: (0/255.0), alpha: 1.0)
            locationVC.view.removeFromSuperview()
            specialVC.view.removeFromSuperview()
            thirdVC.view.frame = self.containerView.frame;
            self.containerView.addSubview(thirdVC.view)
            
            
        }
        
        
        
    }
    
    //MARK - UIAction Methods
    @IBAction func commonBtnAction(_ sender: UIButton) {
        
       // return
       // self.topConstant.constant = 0
       // self.view.setNeedsLayout()
      //  self.topConstant.constant = 0
        self.view.setNeedsLayout()
        setController(index: sender.tag)
        if sender.tag == 0{
            //special btn action
            
        } else if sender.tag == 1{
            //location btn action
            
        } else {
            //third btn action
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
