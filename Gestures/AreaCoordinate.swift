//
//  AreaCoordinate.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 26/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import RealmSwift

class AreaCoordinate: Object {
    dynamic var id = ""
    dynamic var x = 0
    dynamic var y = 0
    
    override var description: String {
        return "(\(x),\(y))"
    }
    
    convenience init(_ x: Int, _ y: Int) {
        self.init()
        self.id = UUID().uuidString
        self.x = x
        self.y = y
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override var hash: Int {
        return (10 * x) + y
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let otherCoordinate = object as? AreaCoordinate else {
            return false
        }
        
        return otherCoordinate.x == self.x && otherCoordinate.y == self.y
    }
}
