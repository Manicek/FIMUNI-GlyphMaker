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
    
    var tuplesCount: Int {
        switch self {
        case .easy: return 5
        case .normal: return 9
        case .hard: return 13
        }
    }
    
    var breakpointsIndexes: [Int] {
        switch self {
        case .easy: return []
        case .normal: return [5]
        case .hard: return [7]
        }
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
        
        let notTooBigOrSmallBreakpointsIndexes = breakpointsIndexes.filter( {$0 < areasIndexes.count - 1 && $0 > 1} ).sorted()
        
        var checkedBreakpointsIndexes = [Int]()
        if !notTooBigOrSmallBreakpointsIndexes.isEmpty {
            checkedBreakpointsIndexes.append(notTooBigOrSmallBreakpointsIndexes[0])
            for i in 1..<notTooBigOrSmallBreakpointsIndexes.count {
                let previousIndex = checkedBreakpointsIndexes.last!
                let currentIndex = notTooBigOrSmallBreakpointsIndexes[i]
                
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
    
    static func generateDeterministicRandomGlyph(_ difficulty: GlyphDifficulty, variant: Int) -> Glyph {
        var tuples = [AreaIndexTuple]()
        var areasIndexes = [AreaIndexTuple]()
        var blockedLines = [Line]()
        let randomizer = AppConstants.randomizer + variant
        var lastIndex = randomizer % difficulty.tuplesCount
        
        for x in 0..<AppConstants.matrixSize {
            for y in 0..<AppConstants.matrixSize {
                tuples.append(AreaIndexTuple(x, y))
            }
        }
        
        areasIndexes.append(tuples[lastIndex])
        
        for i in 1..<difficulty.tuplesCount {
            if difficulty.breakpointsIndexes.contains(i) {
                continue
            }
            
            lastIndex = (lastIndex + randomizer) % tuples.count
            
            var candidateTuple = tuples[lastIndex]
            var candidateLine = Line(from: areasIndexes.last!, to: candidateTuple)
            
            while candidateLine.overlapsAnyLineIn(blockedLines) {
                lastIndex = (lastIndex + 1 == tuples.count) ? 0 : (lastIndex + 1)
                candidateTuple = tuples[lastIndex]
                candidateLine = Line(from: areasIndexes.last!, to: candidateTuple)
            }
            
            areasIndexes.append(candidateTuple)
            blockedLines.append(candidateLine)
        }
        
        return Glyph(name: "\(Date())", difficulty: difficulty, areasIndexes: areasIndexes, breakpointsIndexes: difficulty.breakpointsIndexes)
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
