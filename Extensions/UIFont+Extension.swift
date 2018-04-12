//
//  UIFont+Extension.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 12/04/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

extension UIFont {
    
    class var regularButtonFont: UIFont {
        return regularFont(ofSize: 15)
    }
}


extension UIFont {
    
    class func semiboldFont(ofSize: CGFloat) -> UIFont {
        if let font = UIFont(name: "SFUIText-Semibold", size: ofSize) {
            return font
        }
        return UIFont.boldSystemFont(ofSize: ofSize)
    }
    
    class func heavyFont(ofSize: CGFloat) -> UIFont {
        if let font = UIFont(name: "SFUIText-Heavy", size: ofSize) {
            return font
        }
        return UIFont.boldSystemFont(ofSize: ofSize)
    }
    
    class func mediumFont(ofSize: CGFloat) -> UIFont {
        if let font = UIFont(name: "SFUIText-Medium", size: ofSize) {
            return font
        }
        return UIFont.systemFont(ofSize: ofSize, weight: UIFontWeightMedium)
    }
    
    class func regularFont(ofSize: CGFloat) -> UIFont {
        if let font = UIFont(name: "SFUIText-Regular", size: ofSize) {
            return font
        }
        return UIFont.systemFont(ofSize: ofSize, weight: UIFontWeightRegular)
    }
    
    class func lightFont(ofSize: CGFloat) -> UIFont {
        if let font = UIFont(name: "SFUIText-Light", size: ofSize) {
            return font
        }
        return UIFont.systemFont(ofSize: ofSize, weight: UIFontWeightLight)
    }
}
