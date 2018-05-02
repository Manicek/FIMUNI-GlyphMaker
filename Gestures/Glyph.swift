//
//  Glyph.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 02/05/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import Foundation

class Glyph: NSObject {
    
    private(set) var id = ""
    private(set) var difficulty = GlyphDifficulty.easy
    private(set) var areasCoordinates = [AreaCoordinate]()
    private(set) var breakpointsIndexes = [Int]()
    
    convenience init(areasCoordinates: [AreaCoordinate], breakpointsIndexes: [Int]) {
        var closestDifficulty = GlyphDifficulty.normal
        
        switch areasCoordinates.count {
        case ...6: closestDifficulty = .easy
        case 7...10: closestDifficulty = .normal
        case 11...: closestDifficulty = .hard
        default: break
        }
        
        self.init(difficulty: closestDifficulty, areasCoordinates: areasCoordinates, breakpointsIndexes: breakpointsIndexes)
    }
    
    convenience init(difficulty: GlyphDifficulty, areasCoordinates: [AreaCoordinate], breakpointsIndexes: [Int], id: String? = nil) {
        self.init()
        
        if let id = id {
            self.id = id
        } else {
            self.id = UUID().uuidString
        }
        self.difficulty = difficulty
        self.areasCoordinates = areasCoordinates
        
        let notTooBigOrSmallBreakpointsIndexes = breakpointsIndexes.filter( {$0 < areasCoordinates.count - 1 && $0 > 1} ).sorted()
        
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
        
        self.breakpointsIndexes = checkedBreakpointsIndexes
    }
    
    static let testGlyph = Glyph(difficulty: .easy, areasCoordinates:
        [AreaCoordinate(2, 1), AreaCoordinate(0, 2), AreaCoordinate(2, 3), AreaCoordinate(2, 1), AreaCoordinate(3, 1), AreaCoordinate(3, 3), AreaCoordinate(4, 3), AreaCoordinate(3, 2)], breakpointsIndexes: [4])
    
    /**
     - parameter difficulty: decides length of glyph and breakpoints
     - parameter variant: enables different glyphs of same difficulty
     
     - returns: generated glyph
     */
    static func generateDeterministicRandomGlyph(_ difficulty: GlyphDifficulty, variant: Int) -> Glyph {
        var coordinates = [AreaCoordinate]()
        var areasCoordinates = [AreaCoordinate]()
        var blockedLines = [Line]()
        var randomizer = abs(AppConstants.randomizer.addingReportingOverflow(variant).partialValue)
        var lastIndex = randomizer % difficulty.coordinatesCount
        
        for x in 0..<AppConstants.matrixSize {
            for y in 0..<AppConstants.matrixSize {
                coordinates.append(AreaCoordinate(x, y))
            }
        }
        
        areasCoordinates.append(coordinates[lastIndex])
        
        for i in 1..<difficulty.coordinatesCount {
            if difficulty.breakpointsIndexes.contains(i) {
                continue
            }
            
            lastIndex = (lastIndex + randomizer) % coordinates.count
            
            var candidateCoordinate = coordinates[lastIndex]
            var candidateLine = Line(from: areasCoordinates.last!, to: candidateCoordinate)
            
            while candidateLine.overlapsAnyLineIn(blockedLines) {
                lastIndex = (lastIndex + 1 == coordinates.count) ? 0 : (lastIndex + 1)
                candidateCoordinate = coordinates[lastIndex]
                candidateLine = Line(from: areasCoordinates.last!, to: candidateCoordinate)
            }
            
            areasCoordinates.append(candidateCoordinate)
            blockedLines.append(candidateLine)
            randomizer = abs(randomizer.addingReportingOverflow(randomizer).partialValue)
        }
        
        return Glyph(difficulty: difficulty, areasCoordinates: areasCoordinates, breakpointsIndexes: difficulty.breakpointsIndexes)
    }
    
    /**
     - returns: array of coordinate tuples representing expected first and last areas of all gesture parts
     ### Example: ###
     
     for glyph going from coordinate **c1** to **c2**,
     then breaking and going from **c3** to **c4**,
     the func returns [(**c1**, **c2**), (**c3**, **c4**)]
     
     */
    func expectedBeginEndAreaCoordinates() -> [(AreaCoordinate, AreaCoordinate)] {
        if areasCoordinates.isEmpty {
            return []
        }
        
        if breakpointsIndexes.isEmpty {
            return [(areasCoordinates.first!, areasCoordinates.last!)]
        }
        
        var coordinates = [(AreaCoordinate, AreaCoordinate)]()
        var beginCoordinate = areasCoordinates.first!
        for index in breakpointsIndexes {
            coordinates.append((beginCoordinate, areasCoordinates[index - 1]))
            beginCoordinate = areasCoordinates[index]
        }
        coordinates.append((beginCoordinate, areasCoordinates.last!))
        return coordinates
    }
}
