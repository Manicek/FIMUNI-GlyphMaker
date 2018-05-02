//
//  Line.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 26/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import Foundation

class Line: NSObject {
    private var from: RealmAreaCoordinate
    private var to: RealmAreaCoordinate
    
    init(from: RealmAreaCoordinate, to: RealmAreaCoordinate) {
        self.from = from
        self.to = to
        
        super.init()
    }
    
    override var description: String {
        return "From \(from) to \(to)"
    }
    
    override var hash: Int {
        return from.hashValue * to.hashValue //TODO test me pls
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let otherLine = object as? Line else {
            return false
        }
        
        return (otherLine.from == self.from && otherLine.to == self.to) || (otherLine.from == self.to && otherLine.to == self.from)
    }
    
    func overlaps(_ otherLine: Line) -> Bool {
        for subLine in subLines() {
            for otherSubLine in otherLine.subLines() {
                if otherSubLine == subLine {
                    return true
                }
            }
        }
        return false
    }
    
    func overlapsAnyLineIn(_ lines: [Line]) -> Bool {
        for line in lines {
            if line.overlaps(self) {
                return true
            }
        }
        return false
    }
    
    func subLines() -> [Line] {
        var subLines = [Line]()
        
        let xDiff = to.x - from.x
        let yDiff = to.y - from.y
        
        if xDiff == 0 {
            var y = 0
            
            if yDiff > 0 {
                while y != yDiff {
                    subLines.append(Line(from: RealmAreaCoordinate(from.x, from.y + y), to: RealmAreaCoordinate(from.x, from.y + y + 1)))
                    y += 1
                }
            } else if yDiff < 0 {
                while y != yDiff {
                    subLines.append(Line(from: RealmAreaCoordinate(from.x, from.y + y), to: RealmAreaCoordinate(from.x, from.y + y - 1)))
                    y -= 1
                }
            }
        } else if yDiff == 0 {
            var x = 0
            
            if xDiff > 0 {
                while x != xDiff {
                    subLines.append(Line(from: RealmAreaCoordinate(from.x + x, from.y), to: RealmAreaCoordinate(from.x + x + 1, from.y)))
                    x += 1
                }
            } else if xDiff < 0 {
                while x != xDiff {
                    subLines.append(Line(from: RealmAreaCoordinate(from.x + x, from.y), to: RealmAreaCoordinate(from.x + x - 1, from.y)))
                    x -= 1
                }
            }
        } else if abs(xDiff) == abs(yDiff) {
            var x = 0
            var y = 0
            
            if xDiff > 0 {
                if yDiff > 0 {
                    while y != yDiff {
                        subLines.append(Line(from: RealmAreaCoordinate(from.x + x, from.y + y), to: RealmAreaCoordinate(from.x + x + 1, from.y + y + 1)))
                        y += 1
                        x += 1
                    }
                } else if yDiff < 0 {
                    while y != yDiff {
                        subLines.append(Line(from: RealmAreaCoordinate(from.x + x, from.y + y), to: RealmAreaCoordinate(from.x + x + 1, from.y + y - 1)))
                        y -= 1
                        x += 1
                    }
                }
            } else if xDiff < 0 {
                if yDiff > 0 {
                    while y != yDiff {
                        subLines.append(Line(from: RealmAreaCoordinate(from.x + x, from.y + y), to: RealmAreaCoordinate(from.x + x - 1, from.y + y + 1)))
                        y += 1
                        x -= 1
                    }
                } else if yDiff < 0 {
                    while y != yDiff {
                        subLines.append(Line(from: RealmAreaCoordinate(from.x + x, from.y + y), to: RealmAreaCoordinate(from.x + x - 1, from.y + y - 1)))
                        y -= 1
                        x -= 1
                    }
                }
            }
        }
        
        return subLines
    }
}
