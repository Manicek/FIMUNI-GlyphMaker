//
//  CGRect+Extension.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 15/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

extension CGRect {
    var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
    
    var topCenter: CGPoint {
        return CGPoint(x: midX, y: minY)
    }
    
    var bottomCenter: CGPoint {
        return CGPoint(x: midX, y: maxY)
    }
    
    var leftCenter: CGPoint {
        return CGPoint(x: minX, y: midY)
    }
    
    var rightCenter: CGPoint {
        return CGPoint(x: maxX, y: midY)
    }
}
