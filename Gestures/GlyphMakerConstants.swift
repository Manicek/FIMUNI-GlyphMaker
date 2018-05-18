//
//  GlyphMakerConstants.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 15/05/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

class GlyphMakerConstants: NSObject {
    static var randomizer: Int = 0
    static var numberOfRows: Int = 5
    static var numberOfColumns: Int = 5
    static var lineWidth: CGFloat = 6
    static var allowedOffsetMultiplier: CGFloat = 0.3
    static var drawingTime: TimeInterval = 0.05
    static var inBetweenPointsCountForDrawing: Int = 20
    static var wrongBeginOrEndAreaPenalty: Int = 100
    
    static var lineColor: UIColor = .red
    static var testPathColor: UIColor = .lightGray
    static var testPathOpacity: CGFloat = 0.5
}
