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
}

class AreaIndexTuple: Object {
    dynamic var id = ""
    dynamic var x = 0
    dynamic var y = 0
    
    convenience init(_ x: Int, _ y: Int) {
        self.init()
        self.id = UUID().uuidString
        self.x = x
        self.y = y
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class Glyph: Object {
    dynamic var id = ""
    dynamic var name = ""
    private dynamic var difficultyRaw = GlyphDifficulty.easy.rawValue
    var difficulty: GlyphDifficulty {
        get { return GlyphDifficulty(rawValue: difficultyRaw)! }
        set { difficultyRaw = difficulty.rawValue }
    }
    let areasIndexes = List<AreaIndexTuple>()
    let breakpointsIndexes = List<Int>()
    
    convenience init(name: String, difficulty: GlyphDifficulty, areasIndexes: [AreaIndexTuple], breakpointsIndexes: [Int]) {
        self.init()

        self.id = UUID().uuidString + name
        self.name = name
        self.difficulty = difficulty
        self.areasIndexes.append(objectsIn: areasIndexes)
        self.breakpointsIndexes.append(objectsIn: breakpointsIndexes)
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static var testGlyph: Glyph {
        return Glyph(name: "Test", difficulty: .easy, areasIndexes:
            [AreaIndexTuple(2, 1), AreaIndexTuple(0, 2), AreaIndexTuple(2, 3), AreaIndexTuple(2, 1), AreaIndexTuple(3, 1), AreaIndexTuple(3, 3), AreaIndexTuple(4, 3), AreaIndexTuple(3, 2)], breakpointsIndexes: [4])
    }
}

struct GlyphStore {
    
    static func deleteAllGlyphs() {
        guard let realm = Realm.defaultRealm() else { return }
        
        realm.safeDelete(realm.objects(Glyph.self))
    }
    
    static func getAllGlyphs() -> Results<Glyph>? {
        guard let realm = Realm.defaultRealm() else { return nil }
        
        return realm.objects(Glyph.self)
    }
    
    static func add(glyph: Glyph) {
        guard let realm = Realm.defaultRealm() else { return }
        
        realm.safeAdd(glyph)
    }
    
    static func delete(glyph: Glyph) {
        guard let realm = Realm.defaultRealm() else { return }
        
        realm.safeDelete(glyph)
    }
}
