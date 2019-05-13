//
//  YSTextFieldExtension.swift
//  YellowSeed
//
//  Created by Manoj Singh on 30/04/18.
//  Copyright © 2018 Mobiloitte. All rights reserved.
//

import UIKit

extension UITextField{
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: newValue!])
        }
    }
    
    func setLeftPaddingPoints(_ amount:CGFloat){
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
            self.leftView = paddingView
            self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
            self.rightView = paddingView
            self.rightViewMode = .always
        }
    
  func setLeftPaddingwithImage(image:UIImage){
    
    let btn = UIButton.init(type: .custom)
    btn.setImage(image, for: .normal)
    btn.frame = CGRect(x: 0, y: 0, width: 30, height: self.frame.size.height)
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
    btn.isUserInteractionEnabled = false
    self.leftView = btn
    self.leftViewMode = .always
    
  }
}

