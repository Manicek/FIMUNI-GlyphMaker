//
//  Glyph.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 02/05/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import Foundation

class Glyph: NSObject {
    
    private(set) var areasCoordinates = [AreaCoordinate]()
    private(set) var breakpointsIndexes = [Int]()
    
    convenience init(areasCoordinates: [AreaCoordinate], breakpointsIndexes: [Int]) {
        self.init()
        
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
    
    static let testGlyph = Glyph(areasCoordinates:
        [AreaCoordinate(2, 1), AreaCoordinate(0, 2), AreaCoordinate(2, 3), AreaCoordinate(2, 1), AreaCoordinate(3, 1), AreaCoordinate(3, 3), AreaCoordinate(4, 3), AreaCoordinate(3, 2)], breakpointsIndexes: [4])
    
    static func generateDeterministicRandomGlyph(coordinatesCount: Int, variant: Int, preventOverlaps: Bool) -> Glyph {
        var coordinates = [AreaCoordinate]()
        var areasCoordinates = [AreaCoordinate]()
        var blockedLines = [Line]()
        var randomizer = abs(GlyphMakerConstants.randomizer.addingReportingOverflow(variant).partialValue)
        var lastIndex = randomizer % coordinatesCount
        var breakpointsIndexes = [Int]()
        
        switch coordinatesCount {
        case ...4: break
        case 5...10: breakpointsIndexes.append((randomizer % 2 == 0) ? 2 : 3)
        case 11...:
            breakpointsIndexes.append((randomizer % 2 == 0) ? 2 : 3)
            breakpointsIndexes.append((randomizer % 2 == 0) ? 7 : 8)
        default: break
        }
        
        for x in 0..<GlyphMakerConstants.numberOfRows {
            for y in 0..<GlyphMakerConstants.numberOfColumns {
                coordinates.append(AreaCoordinate(x, y))
            }
        }
        
        areasCoordinates.append(coordinates[lastIndex])
        
        for i in 1..<coordinatesCount {
            if breakpointsIndexes.contains(i) {
                continue
            }
            
            lastIndex = (lastIndex + randomizer) % coordinates.count
            
            var candidateCoordinate = coordinates[lastIndex]
            var candidateLine = Line(from: areasCoordinates.last!, to: candidateCoordinate)
            
            if preventOverlaps {
                while candidateLine.overlapsAnyLineIn(blockedLines) {
                    lastIndex = (lastIndex + 1 == coordinates.count) ? 0 : (lastIndex + 1)
                    candidateCoordinate = coordinates[lastIndex]
                    candidateLine = Line(from: areasCoordinates.last!, to: candidateCoordinate)
                }
            }
            
            areasCoordinates.append(candidateCoordinate)
            blockedLines.append(candidateLine)
            randomizer = abs(randomizer.addingReportingOverflow(randomizer).partialValue)
        }
        
        return Glyph(areasCoordinates: areasCoordinates, breakpointsIndexes: breakpointsIndexes)
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
