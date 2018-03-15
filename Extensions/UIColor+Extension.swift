//
//  UIColor+Extension.swift
//  alberta
//
//  Created by Stanislav Kasprik on 05/12/2017.
//  Copyright © 2017 Stanislav Kasprik. All rights reserved.
//

import UIKit

extension UIColor {
    
    class var mainText: UIColor {
        return UIColor(rgb: 245, 245, 245)
    }
}

extension UIColor {

    convenience init(rgb red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat = 1.0) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
    
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: a)
    }
    
    convenience init(hex: Int) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF
        )
    }
    
    convenience init(hex: Int, _ alpha: CGFloat) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF,
            a: alpha / 100.0
        )
    }
}
