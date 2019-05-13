//
//  UserDefaults.swift
//  YellowSeed
//
//  Created by Sunil Verma on 23/05/18.
//  Copyright © 2018 Mobiloitte. All rights reserved.
//

import Foundation
import UIKit

extension UserDefaults {
  func set(_ color: UIColor, forKey key: String) {
    set(NSKeyedArchiver.archivedData(withRootObject: color), forKey: key)
  }
  func color(forKey key: String) -> UIColor? {
    guard let data = data(forKey: key) else { return nil }
    return NSKeyedUnarchiver.unarchiveObject(with: data) as? UIColor
  }
  
  func imageForKey(key: String) -> UIImage? {
    var image: UIImage?
    if let imageData = data(forKey: key) {
      image = NSKeyedUnarchiver.unarchiveObject(with: imageData) as? UIImage
    }
    return image
  }
  func setImage(image: UIImage?, forKey key: String) {
    var imageData: NSData?
    if let image = image {
      imageData = NSKeyedArchiver.archivedData(withRootObject: image) as NSData?
    }
    set(imageData, forKey: key)
  }
}
