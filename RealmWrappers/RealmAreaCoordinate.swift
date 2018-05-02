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
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(from areaCoordinate: AreaCoordinate) {
        self.init()
        
        self.x = areaCoordinate.x
        self.y = areaCoordinate.y
    }
    
    func toAreaCoordinate() -> AreaCoordinate {
        return AreaCoordinate(x, y)
    }
}
