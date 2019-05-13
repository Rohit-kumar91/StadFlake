//
//  MCCustomAlertController.swift
//  MeClub
//
//  Created by Probir Chakraborty on 19/07/17.
//  Copyright © 2017 Mobiloitte. All rights reserved.
//

import UIKit

class MCCustomAlertController: UIAlertController {
    
    // MARK: - Singleton
    
    class var instance : MCCustomAlertController {
        struct Static {
            static let inst : MCCustomAlertController = MCCustomAlertController ()
        }
        return Static.inst
    }
    
    // MARK: - Private Functions
    
    private func topMostController() -> UIViewController? {
        
        var presentedVC = UIApplication.shared.keyWindow?.rootViewController
        while let pVC = presentedVC?.presentedViewController {
            presentedVC = pVC
        }
        
        if presentedVC == nil {
            //print("AlertController Error: You don't have any views set. You may be calling in viewdidload. Try viewdidappear.")
        }
        return presentedVC
    }
    
    // MARK: - Class Functions
    
    @discardableResult  public class func alert(title: String) -> UIAlertController {
        return alert(title: title, message: "")
    }
    
    @discardableResult  public class func alert(title: String, message: String) -> UIAlertController {
        
        return alert(title: title, message: message, acceptMessage: "OK", acceptBlock: {
            //
        })
        
    }
    
    @discardableResult  public class func alert(title: String, message: String, acceptMessage: String, acceptBlock: @escaping () -> ()) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let acceptButton = UIAlertAction(title: acceptMessage, style: .default, handler: { (action: UIAlertAction) in
            acceptBlock()
        })
        alert.addAction(acceptButton)
        
        MCCustomAlertController.instance.topMostController()?.present(alert, animated: true, completion: nil)
        return alert
    }
    
    @discardableResult public class func alert(title: String, message: String, buttons:[String], tapBlock:((UIAlertAction,Int) -> Void)?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert, buttons: buttons, tapBlock: tapBlock)
        MCCustomAlertController.instance.topMostController()?.present(alert, animated: true, completion: nil)
        return alert
    }
    
    @discardableResult public class func actionSheet(title: String, message: String, sourceView: UIView, actions: [UIAlertAction]) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.actionSheet)
        for action in actions {
            alert.addAction(action)
        }
        
        alert.popoverPresentationController?.sourceView = sourceView
        alert.popoverPresentationController?.sourceRect = sourceView.bounds
        MCCustomAlertController.instance.topMostController()?.present(alert, animated: true, completion: nil)
        return alert
    }
    
    @discardableResult public class func actionSheet(title: String, message: String, sourceView: UIView, buttons:[String], tapBlock:((UIAlertAction,Int) -> Void)?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet, buttons: buttons, tapBlock: tapBlock)
        alert.popoverPresentationController?.sourceView = sourceView
        alert.popoverPresentationController?.sourceRect = sourceView.bounds
        MCCustomAlertController.instance.topMostController()?.present(alert, animated: true, completion: nil)
        return alert
    }
    
}
private extension UIAlertController {
    convenience init(title: String?, message: String?, preferredStyle: UIAlertControllerStyle, buttons:[String], tapBlock:((UIAlertAction,Int) -> Void)?) {
        self.init(title: title, message: message, preferredStyle:preferredStyle)
        var buttonIndex = 0
        for buttonTitle in buttons {
            let action = UIAlertAction(title: buttonTitle, preferredStyle: .default, buttonIndex: buttonIndex, tapBlock: tapBlock)
            buttonIndex += 1
            self.addAction(action)
        }
    }
}

private extension UIAlertAction {
    convenience init(title: String?, preferredStyle: UIAlertActionStyle, buttonIndex:Int, tapBlock:((UIAlertAction,Int) -> Void)?) {
        self.init(title: title, style: preferredStyle) {
            (action:UIAlertAction) in
            if let block = tapBlock {
                block(action,buttonIndex)
            }
        }
    }
}

