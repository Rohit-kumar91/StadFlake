//
//  YSStringExtension.swift
//  YellowSeed
//
//  Created by Manoj Singh on 30/04/18.
//  Copyright © 2018 Mobiloitte. All rights reserved.
//

import UIKit

extension String {
    
    func contains(_ string: String) -> Bool {
        return self.range(of: string) != nil
    }
    
    func substringFromIndex(_ index: Int) -> String {
        if (index < 0 || index > self.count) {
            //print("index \(index) out of bounds")
            return ""
        }
        return self.substring(from: self.index(self.startIndex, offsetBy: index))
    }
    
    func substringToIndex(_ index: Int) -> String {
        if (index < 0 || index > self.count) {
            //print("index \(index) out of bounds")
            return ""
        }
        return self.substring(to: self.index(self.startIndex, offsetBy: index))
    }
    func subStringWithRange(_ start: Int, end: Int) -> String {
        if (start < 0 || start > self.count) {
            //print("start index \(start) out of bounds")
            return ""
        } else if end < 0 || end > self.count {
            //print("end index \(end) out of bounds")
            return ""
        }
        
        let range = (self.index(self.startIndex, offsetBy: start) ..< self.index(self.startIndex, offsetBy: end))
        return self.substring(with: range)
    }
    
    func subStringWithRange(_ start: Int, location: Int) -> String {
        if (start < 0 || start > self.count) {
            //print("start index \(start) out of bounds")
            return ""
        } else if location < 0 || start + location > self.count {
            //print("end index \(start + location) out of bounds")
            return ""
        }
        let range = (self.index(self.startIndex, offsetBy: start) ..< self.index(self.startIndex, offsetBy: start + location))
        return self.substring(with: range)
    }
    
    var trimWhiteSpace: String {
        let trimmedString = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return trimmedString
    }
    
    var length: Int {
        return self.count
    }
    
    var extractNumber: String {
        
        let numbers = self.components(separatedBy: CharacterSet.decimalDigits.inverted)
        let userNumber = numbers.joined(separator: "") // Using space as separator
        
        return userNumber
    }
    
    
    //>>>> removes all whitespace from a string, not just trailing whitespace <<<//
    
    var removeWhiteSpaces: String {
        return self.replaceString(" ", withString: "")
    }
    
    //>>>> Replacing String with String <<<//
    func replaceString(_ string:String, withString:String) -> String {
        return self.replacingOccurrences(of: string, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func dateFromString(_ format: String) -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            print("Unable to format date")
        }
        
        return nil
    }
    
    func dateFromUTC() -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"
        
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            print("Unable to format date")
        }
        
        return nil
    }
    
    func stringToDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/M/yyyy, hh:mm a" //Your date format
        if let date = dateFormatter.date(from: self) {
            return date
        }
        return nil
    }
    
    func heightWithConstraints(width: CGFloat, font: UIFont) -> CGFloat {
        
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return boundingBox.height
    }
    
    func toJson() -> AnyObject? {
        
        if let data = self.data(using: String.Encoding.utf8) {
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                
                return json as AnyObject?
            } catch {
                //print("Something went wrong    \(text)")
            }
        }
        
        return nil
    }
    
    func toDictionary() -> [String:AnyObject]? {
        if let data = self.data(using: String.Encoding.utf8) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
                return json
            } catch {
                //print("Something went wrong    \(text)")
            }
        }
        return nil
    }
    
    func jwtTokenInfo() -> Dictionary<String, AnyObject>? {
        
        let segments = self.components(separatedBy: ".")
        
        var base64String = segments[1] as String
        
        if base64String.count % 4 != 0 {
            let padlen = 4 - base64String.count % 4
            base64String += String(repeating: "=", count: padlen)
        }
        
        if let data = Data(base64Encoded: base64String, options: []) {
            do {
                let tokenInfo = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
                return tokenInfo as? Dictionary<String, AnyObject>
            } catch {
                //  Debug.log("error to generate jwtTokenInfo >>>>>>  \(error)")
            }
        }
        return nil
    }
    
    var getPathExtension: String {
        return (self as NSString).pathExtension
    }
    
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
    func substring(_ from: Int) -> String {
        return self.substring(from: self.index(self.startIndex, offsetBy: from))
    }
    
    /*>>>>>>>>>>>>>>>>>>>>>>>>>>>> Get Attributed String <<<<<<<<<<<<<<<<<<<<<<<<*/
    
    func getAttributedString(_ string_to_Attribute:String, color:UIColor, font:UIFont) -> NSAttributedString {
        
        let range = (self as NSString).range(of: string_to_Attribute)
        
        let attributedString = NSMutableAttributedString(string:self)
        
        // multiple attributes declared at once
        let multipleAttributes = [
            NSAttributedStringKey.foregroundColor: color,
            NSAttributedStringKey.font: font,
            ]
        
        attributedString.addAttributes(multipleAttributes, range: range)
        
        return attributedString.mutableCopy() as! NSAttributedString
    }
  
  func getAttributedString(_ string1:String, string2:String, color:UIColor, font:UIFont) -> NSAttributedString {
    
    let range = (self as NSString).range(of: string1)
    
    let range2 = (self as NSString).range(of: string2)

    let attributedString = NSMutableAttributedString(string:self)
    
    // multiple attributes declared at once
    let multipleAttributes = [
      NSAttributedStringKey.foregroundColor: color,
      NSAttributedStringKey.font: font,
      ]
    
    attributedString.addAttributes(multipleAttributes, range: range)
    
    attributedString.addAttributes(multipleAttributes, range: range2)

    return attributedString.mutableCopy() as! NSAttributedString
  }
    
    func getUnderLinedAttributedString() -> NSAttributedString {
        
        let underlineAttribute = [NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue]
        let underlineAttributedString = NSAttributedString(string: self, attributes: underlineAttribute)
        
        return underlineAttributedString
    }
    
    // Returns a range of characters (e.g. s[0...3])
    
    subscript (r: Range<Int>) -> String {
        let start = self.index(self.startIndex, offsetBy: r.lowerBound)
        let end = self.index(self.startIndex, offsetBy: r.upperBound)
        return substring(with: (start ..< end))
    }
    
    
}


extension NSMutableAttributedString {
    
    
    func appendAttribute(_ string_to_Attribute:String, color:UIColor, font:UIFont){
        
        let range = (self.string as NSString).range(of: string_to_Attribute)

        let multipleAttributes = [
            NSAttributedStringKey.foregroundColor: color,
            NSAttributedStringKey.font: font,
            ]
        
        self.addAttributes(multipleAttributes, range: range)
        
//        return self.mutableCopy() as! NSAttributedString
    }
}
