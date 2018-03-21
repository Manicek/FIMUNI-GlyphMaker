//
//  UIView+Extension.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 29/01/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

extension UIView {
    
    func addSubviews(_ subviews: [UIView]) {
        for subview in subviews {
            addSubview(subview)
        }
    }
}
