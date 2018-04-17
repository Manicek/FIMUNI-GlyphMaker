//
//  UIBezierPath+Extension.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 17/04/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

extension UIBezierPath {
    static func newPath() -> UIBezierPath {
        let path = UIBezierPath()
        path.lineWidth = AppConstants.lineWidth
        return path
    }
}
