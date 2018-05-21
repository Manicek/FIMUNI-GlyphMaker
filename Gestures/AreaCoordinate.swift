//
//  AreaCoordinate.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 02/05/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import Foundation

class AreaCoordinate: NSObject {
    
    private(set) var x = 0
    private(set) var y = 0
    
    static var nonExistent = AreaCoordinate(-1, -1)
    
    override var description: String {
        return "(\(x),\(y))"
    }
    
    convenience init(_ x: Int, _ y: Int) {
        self.init()
        
        self.x = x
        self.y = y        
    }
    
    override var hash: Int {
        return (10000000 * x) + y
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let otherCoordinate = object as? AreaCoordinate else {
            return false
        }
        
        return otherCoordinate.x == self.x && otherCoordinate.y == self.y
    }
}
