//
//  AreaCoordinate.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 26/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import RealmSwift

class RealmAreaCoordinate: Object {
    @objc dynamic var id = ""
    @objc dynamic var x = 0
    @objc dynamic var y = 0
    
    static var nonExistent = RealmAreaCoordinate(-1, -1)
    
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
        guard let otherCoordinate = object as? RealmAreaCoordinate else {
            return false
        }
        
        return otherCoordinate.x == self.x && otherCoordinate.y == self.y
    }
}
