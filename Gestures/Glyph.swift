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
        
        let notTooBigBreakpointsIndexes = breakpointsIndexes.filter( {$0 < areasIndexes.count - 1 && $0 > 1} ).sorted()
        
        var checkedBreakpointsIndexes = [Int]()
        if !notTooBigBreakpointsIndexes.isEmpty {
            checkedBreakpointsIndexes.append(notTooBigBreakpointsIndexes[0])
            for i in 1..<notTooBigBreakpointsIndexes.count {
                let previousIndex = checkedBreakpointsIndexes.last!
                let currentIndex = notTooBigBreakpointsIndexes[i]
                
                if currentIndex != previousIndex && currentIndex != previousIndex + 1 {
                    checkedBreakpointsIndexes.append(currentIndex)
                }
            }
        }
        
        self.breakpointsIndexes.append(objectsIn: checkedBreakpointsIndexes)
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static let testGlyph = Glyph(name: "Test", difficulty: .easy, areasIndexes:
            [AreaIndexTuple(2, 1), AreaIndexTuple(0, 2), AreaIndexTuple(2, 3), AreaIndexTuple(2, 1), AreaIndexTuple(3, 1), AreaIndexTuple(3, 3), AreaIndexTuple(4, 3), AreaIndexTuple(3, 2)], breakpointsIndexes: [4])
    
    static func generateRandomGlyph() -> Glyph {
        let name = "\(Date())"
        let difficulty = GlyphDifficulty.easy
        let numberOfPoints = randomInt(6) + 3
        let breakpointIndex = randomInt(numberOfPoints - 1)
        var areasIndexes = [AreaIndexTuple]()
        for _ in 0..<numberOfPoints {
            areasIndexes.append(AreaIndexTuple(randomInt(AppConstants.matrixSize), randomInt(AppConstants.matrixSize)))
        }
        return Glyph(name: name, difficulty: difficulty, areasIndexes: areasIndexes, breakpointsIndexes: [breakpointIndex])
    }
    
    func expectedBegindEndAreaIndexTuples() -> [[AreaIndexTuple]] {
        if areasIndexes.isEmpty {
            return []
        }

        if breakpointsIndexes.isEmpty {
            return [[areasIndexes.first!, areasIndexes.last!]]
        }
        
        var tuples = [[AreaIndexTuple]]()
        var beginTuple = areasIndexes.first!
        for index in breakpointsIndexes {
            tuples.append([beginTuple, areasIndexes[index - 1]])
            beginTuple = areasIndexes[index]
        }
        tuples.append([beginTuple, areasIndexes.last!])
        return tuples
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

fileprivate func randomInt(_ upperBound: Int) -> Int {
    return Int(arc4random_uniform(UInt32(upperBound)))
}
