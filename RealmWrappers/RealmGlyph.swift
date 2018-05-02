//
//  Glyph.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 15/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import RealmSwift

enum GlyphDifficulty: Int {
    case easy = 0
    case normal = 1
    case hard = 2
    
    var coordinatesCount: Int {
        switch self {
        case .easy: return 5
        case .normal: return 8
        case .hard: return 13
        }
    }
    
    var breakpointsIndexes: [Int] {
        switch self {
        case .easy: return []
        case .normal: return [4]
        case .hard: return [7]
        }
    }
}

class RealmGlyph: Object {
    @objc dynamic var id = ""
    @objc private dynamic var difficultyRaw = GlyphDifficulty.easy.rawValue
    var difficulty: GlyphDifficulty {
        get { return GlyphDifficulty(rawValue: difficultyRaw)! }
        set { difficultyRaw = difficulty.rawValue }
    }
    let areasCoordinates = List<RealmAreaCoordinate>()
    let breakpointsIndexes = List<Int>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(from glyph: Glyph) {
        self.init()
        
        self.id = glyph.id
        self.difficulty = glyph.difficulty
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

        return Glyph(difficulty: difficulty, areasCoordinates: normalAreasCoordinates, breakpointsIndexes: normalBreakpoints, id: id)
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
