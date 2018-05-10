//
//  Glyph.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 15/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import RealmSwift

class RealmGlyph: Object {
    @objc dynamic var id = ""
    let areasCoordinates = List<RealmAreaCoordinate>()
    let breakpointsIndexes = List<Int>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(from glyph: Glyph) {
        self.init()
        
        self.id = UUID().uuidString
        for areaCoordinate in glyph.areasCoordinates {
            self.areasCoordinates.append(RealmAreaCoordinate(from: areaCoordinate))
        }
        self.breakpointsIndexes.append(objectsIn: glyph.breakpointsIndexes)
    }
    
    func toGlyph() -> Glyph {
        var normalAreasCoordinates = [AreaCoordinate]()
        for realmAreaCoordinate in areasCoordinates {
            normalAreasCoordinates.append(realmAreaCoordinate.toAreaCoordinate())
        }
        let normalBreakpoints = Array(breakpointsIndexes)

        return Glyph(areasCoordinates: normalAreasCoordinates, breakpointsIndexes: normalBreakpoints)
    }
}

struct GlyphStore {
    
    static func deleteAllGlyphs() {
        guard let realm = Realm.defaultRealm() else { return }
        
        realm.safeDelete(realm.objects(RealmGlyph.self))
    }
    
    static func getAllGlyphs() -> Results<RealmGlyph>? {
        guard let realm = Realm.defaultRealm() else { return nil }
        
        return realm.objects(RealmGlyph.self)
    }
    
    static func add(glyph: RealmGlyph) {
        guard let realm = Realm.defaultRealm() else { return }
        
        realm.safeAdd(glyph)
    }
    
    static func delete(glyph: RealmGlyph) {
        guard let realm = Realm.defaultRealm() else { return }
        
        realm.safeDelete(glyph)
    }
}
