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
        static let drawingTime: TimeInterval = 0.05
        static let inBetweenPointsCount = 20
    }
    
    weak var rowsManager: RowsManager? {
        didSet {
            guard let rows = rowsManager?.rows else {
                return
            }
            areaSize = rows[0][0].height
        }
    }
    
    fileprivate var glyph = Glyph.testGlyph
    
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
    fileprivate var pointArray = [CGPoint]()
    
    fileprivate var isAlreadySetup = false
    
    init() {
        super.init(frame: CGRect())
        
        recreatePath()
        
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(with glyph: Glyph) {
        log.debug()
        if isAlreadySetup {
            return
        }
        isAlreadySetup = true
        
        guard let rows = rowsManager?.rows, !glyph.areasIndexes.isEmpty else {
            return
        }
        
        self.glyph = glyph
        
        areaIndexTuples = Array(glyph.areasIndexes)
        breakpointsIndexes = Array(glyph.breakpointsIndexes)
        
        createExpectedBegindAndEndAreas(rows: rows)
        createPointArrayAndTestRectPaths(rows: rows)
        
        print("pointArray count: \(pointArray.count)")
        print("breakpointIndex: \(breakpointsIndexes)")
        print("areasIndexes count: \(areaIndexTuples.count)")
        print("testPaths count: \(testPaths.count)")
        
        setNeedsDisplay()
    }
    
    func clear() {
        log.debug()
        recreatePath()
        okPoints = 0
        nokPoints = 0
        expectedBeginAndEndAreasIndex = 0
        expectedPathIndex = 0
        setNeedsDisplay()
    }
    
    func drawGlyph() {
        log.debug()
        
        drawingTimer?.invalidate()
        drawingTimer = nil
        drawingTimerCounter = 0
        
        recreatePath()
        
        drawingTimer = Timer.scheduledTimer(timeInterval: Const.drawingTime, target: self, selector: #selector(drawingTimerUpdate), userInfo: nil, repeats: true)
    }
    
    func drawingTimerUpdate() {
        if drawingTimerCounter == pointArray.count {
            drawingTimer?.invalidate()
            drawingTimer = nil
            return
        }
        
        let condition = drawingTimerCounter % Const.inBetweenPointsCount == 0 && breakpointsIndexes.contains((drawingTimerCounter / Const.inBetweenPointsCount) + 1)
        
        let nextPoint = pointArray[drawingTimerCounter]
        if condition || drawingTimerCounter == 0 {
            path.move(to: nextPoint)
        } else {
            path.addLine(to: nextPoint)
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
                log.warning("Not starting in begin area")
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let currentPoint = touch.location(in: self)
            
            if testPaths[expectedPathIndex].contains(currentPoint) {
                okPoints += 1
                print("ok: \(okPoints)")
            } else if (expectedPathIndex + 1) < testPaths.count && testPaths[expectedPathIndex + 1].contains(currentPoint) {
                okPoints += 1
                expectedPathIndex += 1
                print("ok: \(okPoints) moving to next: \(expectedPathIndex)")
            } else {
                nokPoints += 1
                var actual = [Int]()
                for i in 0..<testPaths.count {
                    if testPaths[i].contains(currentPoint) {
                        actual.append(i)
                    }
                }
                print("nok: \(nokPoints), expected: \(expectedPathIndex), actual: \(actual)")
            }
            
            drawLine(toPoint: currentPoint)
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        log.debug()
        if let touch = touches.first {
            if !expectedBeginAndEndAreas[expectedBeginAndEndAreasIndex].last!.contains(touch.location(in: self)) {
                log.warning("Not ending in end area")
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
    
    func drawLine(toPoint: CGPoint) {
        path.addLine(to: toPoint)
        setNeedsDisplay()
    }
    
    func recreatePath() {
        log.debug()
        path = UIBezierPath()
        path.lineWidth = AppConstants.lineWidth
    }
    
    func createExpectedBegindAndEndAreas(rows: [[CGRect]]) {
        log.debug()
        expectedBeginAndEndAreas = [[CGRect]]()
        
        for tupleDuo in glyph.expectedBegindEndAreaIndexTuples() {
            let firstTuple = tupleDuo.first!
            let lastTuple = tupleDuo.last!
            expectedBeginAndEndAreas.append([rows[firstTuple.x][firstTuple.y], rows[lastTuple.x][lastTuple.y]])
        }
    }
    
    func createPointArrayAndTestRectPaths(rows: [[CGRect]]) {
        log.debug()
        
        let linesCount = areaIndexTuples.count - (1 + breakpointsIndexes.count)
        pointArray = [CGPoint](repeating: CGPoint.zero, count: linesCount * Const.inBetweenPointsCount)
        testPaths = [UIBezierPath]()
        
        var arrayIndex = 0
        
        for i in 0..<areaIndexTuples.count - 1 {
            if breakpointsIndexes.contains(i + 1) {
                continue
            }
            let fromTuple = areaIndexTuples[i]
            let toTuple = areaIndexTuples[i + 1]
            let fromPoint = rows[fromTuple.x][fromTuple.y].center
            let toPoint = rows[toTuple.x][toTuple.y].center
            let xDiff = (fromPoint.x - toPoint.x) / CGFloat(Const.inBetweenPointsCount)
            let yDiff = (fromPoint.y - toPoint.y) / CGFloat(Const.inBetweenPointsCount)
            var currentX = fromPoint.x
            var currentY = fromPoint.y
            
            testPaths.append(createAreaPathBetweenPoints(fromPoint, toPoint))
            
            for _ in 0..<Const.inBetweenPointsCount {
                pointArray[arrayIndex] = CGPoint(x: currentX, y: currentY)
                currentX -= xDiff
                currentY -= yDiff
                arrayIndex += 1
            }
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
