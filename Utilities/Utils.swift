//
//  Utils.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 25/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import Foundation

class Utils: NSObject {
    
    static func randomInt(_ upperBound: Int) -> Int {
        return Int(arc4random_uniform(UInt32(upperBound)))
    }
}
