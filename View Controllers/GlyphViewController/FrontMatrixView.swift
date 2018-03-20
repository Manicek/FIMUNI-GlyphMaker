//
//  FrontMatrixView.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 15/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

class FrontMatrixView: UIView {
    
    struct Const {
        static let drawingTime: TimeInterval = 4
    }
    
    weak var rowsManager: RowsManager? {
        didSet {
            guard let rows = rowsManager?.rows else {
                return
            }
            areaSize = rows[0][0].height
        }
    }
    
    fileprivate var path = UIBezierPath()
    fileprivate var lastPoint = CGPoint.zero
    
    fileprivate var testPaths = [UIBezierPath]()
    
    fileprivate var areaSize: CGFloat = 1
    
    fileprivate var expectedPathIndex = 0
    fileprivate var expectedBeginAndEndAreasIndex = 0
    fileprivate var expectedBeginAndEndAreas = [[CGRect]]()
    
    fileprivate var okPoints = 0
    fileprivate var nokPoints = 0
    
    fileprivate var drawingTimer: Timer?
    fileprivate var drawingTimerCounter = 0
    fileprivate var areaIndexTuples = [AreaIndexTuple]()
    fileprivate var breakpointsIndexes = [Int]()
    
    init() {
        super.init(frame: CGRect())
        
        recreatePath()
        
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func clear() {
        recreatePath()
        okPoints = 0
        nokPoints = 0
        expectedBeginAndEndAreasIndex = 0
        setNeedsDisplay()
    }
    
    func setup(with glyph: Glyph) {
        guard let rows = rowsManager?.rows else {
            return
        }
        
        createTestRectPaths(for: glyph, rows: rows)
        createExpectedBegindAndEndAreas(for: glyph, rows: rows)
        setNeedsDisplay()
    }
    
    func drawGlyph(_ glyph: Glyph) {
        log.debug()
        
        drawingTimer?.invalidate()
        drawingTimer = nil
        drawingTimerCounter = 0
        
        if glyph.areasIndexes.isEmpty {
            return
        }
        
        recreatePath()
        
        areaIndexTuples = Array(glyph.areasIndexes)
        breakpointsIndexes = Array(glyph.breakpointsIndexes)

        drawingTimer = Timer.scheduledTimer(timeInterval: Const.drawingTime / TimeInterval(areaIndexTuples.count), target: self, selector: #selector(drawingTimerUpdate), userInfo: nil, repeats: true)
    }

    func drawingTimerUpdate() {
        log.debug()
        guard let rows = rowsManager?.rows, drawingTimerCounter != areaIndexTuples.count else {
            drawingTimer?.invalidate()
            drawingTimer = nil
            return
        }
        
        let nextTuple = areaIndexTuples[drawingTimerCounter]
        
        let nextPoint = rows[nextTuple.x][nextTuple.y].center
        
        if breakpointsIndexes.contains(drawingTimerCounter) || drawingTimerCounter == 0 {
            path.move(to: nextPoint)
            print("moving to \(nextPoint)")
        } else {
            path.addLine(to: nextPoint)
            print("adding line to \(nextPoint)")
        }
        
        setNeedsDisplay()
        
        drawingTimerCounter += 1
    }
    
    override func draw(_ rect: CGRect) {
        
        UIColor.green.setFill()
        for testPath in testPaths {
            testPath.fill()
        }
        
        UIColor.red.setStroke()
        path.stroke()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        log.debug()
        if let touch = touches.first {
            let firstPoint = touch.location(in: self)
            lastPoint = firstPoint
            path.move(to: firstPoint)
            
            if !expectedBeginAndEndAreas[expectedBeginAndEndAreasIndex].first!.contains(firstPoint) {
                log.error("Not starting in begin area")
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let currentPoint = touch.location(in: self)
            
            if testPaths[expectedPathIndex].contains(currentPoint) {
                okPoints += 1
            } else if (expectedPathIndex + 1) < testPaths.count && testPaths[expectedPathIndex + 1].contains(currentPoint) {
                okPoints += 1
                expectedPathIndex += 1
            } else {
                nokPoints += 1
            }
            
            drawLineFrom(fromPoint: lastPoint, toPoint: currentPoint)
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        log.debug()
        if let touch = touches.first {
            if !expectedBeginAndEndAreas[expectedBeginAndEndAreasIndex].last!.contains(touch.location(in: self)) {
                log.error("Not ending in end area")
            }
        }
        if expectedBeginAndEndAreasIndex + 1 == expectedBeginAndEndAreas.count {
            expectedBeginAndEndAreasIndex = 0
        } else {
            expectedBeginAndEndAreasIndex += 1
        }
        
        print("ok: \(okPoints)")
        print("nok: \(nokPoints)")
    }
}

fileprivate extension FrontMatrixView {
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        log.debug()
        
        path.addLine(to: toPoint)
        
        setNeedsDisplay()
    }
    
    func recreatePath() {
        log.debug()
        path = UIBezierPath()
        path.lineWidth = AppConstants.lineWidth
    }
    
    func createExpectedBegindAndEndAreas(for glyph: Glyph, rows: [[CGRect]]) {
        log.debug()
        expectedBeginAndEndAreas = [[CGRect]]()
        
        for tupleDuo in glyph.expectedBegindEndAreaIndexTuples() {
            let firstTuple = tupleDuo.first!
            let lastTuple = tupleDuo.last!
            expectedBeginAndEndAreas.append([rows[firstTuple.x][firstTuple.y], rows[lastTuple.x][lastTuple.y]])
        }
    }
    
    func createTestRectPaths(for glyph: Glyph, rows: [[CGRect]]) {
        log.debug()
        let areasIndexes = glyph.areasIndexes
        if areasIndexes.count == 0 {
            return
        }
        
        var iterator = areasIndexes.makeIterator()
        
        let currentIndex = iterator.next()!
        
        var lastPoint = rows[currentIndex.x][currentIndex.y].center
        
        for i in 1..<areasIndexes.count {
            let nextTuple = iterator.next()!
            
            let nextPoint = rows[nextTuple.x][nextTuple.y].center
            
            if !glyph.breakpointsIndexes.contains(i) {
                testPaths.append(createAreaPathBetweenPoints(lastPoint, nextPoint))
            }
            lastPoint = nextPoint
        }
    }
    
    func createAreaPathBetweenPoints(_ first: CGPoint, _ second: CGPoint) -> UIBezierPath {
        let path = UIBezierPath()
        path.lineWidth = AppConstants.lineWidth
        
        var offset = AppConstants.allowedOffsetMultiplier * areaSize
        
        let xDiff = fabs(first.x - second.x)
        let yDiff = fabs(first.y - second.y)
        
        if xDiff != 1 && yDiff != 1 {
            offset *= CGFloat(2).squareRoot()
        }
        
        let diffSum = xDiff + yDiff
        let xMultiplier = yDiff / diffSum * (first.x - second.x > 0 ? -1 : 1)
        let yMultiplier = xDiff / diffSum * (first.y - second.y < 0 ? -1 : 1)
        
        if xMultiplier != 1 && yMultiplier != 1 {
            offset *= CGFloat(2).squareRoot()
        }
        
        let firstCorner1 = CGPoint(x: first.x + xMultiplier * offset, y: first.y + yMultiplier * offset)
        let firstCorner2 = CGPoint(x: first.x - xMultiplier * offset, y: first.y - yMultiplier * offset)
        
        let secondCorner1 = CGPoint(x: second.x + xMultiplier * offset, y: second.y + yMultiplier * offset)
        let secondCorner2 = CGPoint(x: second.x - xMultiplier * offset, y: second.y - yMultiplier * offset)
        
        path.move(to: firstCorner1)
        path.addLine(to: firstCorner2)
        path.addLine(to: secondCorner2)
        path.addLine(to: secondCorner1)
        path.close()
        
        return path
    }
}
