//
//  DamageType.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 18/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

enum DamageType: Int {
    case fire = 0
    case cold = 1
    
    var color: UIColor {
        switch self {
        case .fire: return .fireRed
        case .cold: return .coldBlue
        }
    }
    
    var name: String {
        switch self {
        case .fire: return "Fire"
        case .cold: return "Cold"
        }
    }
}
