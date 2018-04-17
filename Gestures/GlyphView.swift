//
//  GlyphView.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 15/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

protocol GlyphViewDelegate: class {
    func finishedGlyphWithResults(okPointsPercentage: Double)
}

class GlyphView: RowsView {
    
    struct Const {
        static let drawingTime: TimeInterval = 0.05
        static let inBetweenPointsCountForDrawing = 20
    }
    
    weak var delegate: GlyphViewDelegate?
    
    fileprivate var glyph = Glyph.testGlyph
    
    fileprivate var lastPoint = CGPoint.zero
    
    fileprivate var testPaths = [TestPath]()
    
    fileprivate var expectedPathIndex = 0
    fileprivate var expectedBeginAndEndAreasIndex = 0
    fileprivate var expectedBeginAndEndAreas = [[CGRect]]()
    
    fileprivate var okPoints = 0
    fileprivate var nokPoints = 0
    
    fileprivate var drawingTimer: Timer?
    fileprivate var drawingTimerCounter = 0
    fileprivate var areaCoordinates = [AreaCoordinate]()
    fileprivate var breakpointsIndexes = [Int]()
    fileprivate var pointArray = [CGPoint]()
    
    fileprivate var isAlreadySetup = false
    fileprivate var shouldDisplayTestPaths = true
    
    override init() {
        super.init()
        
        isUserInteractionEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with glyph: Glyph, forcefully: Bool = false) {
        log.debug()
        if isAlreadySetup && !forcefully {
            return
        }
        isAlreadySetup = true
        
        self.glyph = glyph
        
        areaCoordinates = Array(glyph.areasCoordinates)
        breakpointsIndexes = Array(glyph.breakpointsIndexes)
        
        createExpectedBeginAndEndAreas()
        createPointArrayAndTestRectPaths()
        
        print("pointArray count: \(pointArray.count)")
        print("breakpointIndex: \(breakpointsIndexes)")
        print("areasCoordinates count: \(areaCoordinates.count)")
        print("testPaths count: \(testPaths.count)")
        print("expectedBeginAndEndAreas count: \(expectedBeginAndEndAreas.count)")
        
        isUserInteractionEnabled = true
        setNeedsDisplay()
    }
    
    func clear() {
        log.debug()
        drawingTimer?.invalidate()
        drawingTimer = nil
        drawingTimerCounter = 0
        path = UIBezierPath.newPath()
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
        
        path = UIBezierPath.newPath()
        
        drawingTimer = Timer.scheduledTimer(timeInterval: Const.drawingTime, target: self, selector: #selector(drawingTimerUpdate), userInfo: nil, repeats: true)
    }
    
    func drawingTimerUpdate() {
        if drawingTimerCounter == pointArray.count {
            drawingTimer?.invalidate()
            drawingTimer = nil
            return
        }
        
        let shouldMove = drawingTimerCounter % Const.inBetweenPointsCountForDrawing == 0 && breakpointsIndexes.contains((drawingTimerCounter / Const.inBetweenPointsCountForDrawing) + 1)
        
        let nextPoint = pointArray[drawingTimerCounter]
        if shouldMove || drawingTimerCounter == 0 {
            path.move(to: nextPoint)
        } else {
            path.addLine(to: nextPoint)
        }
        
        setNeedsDisplay()
        
        drawingTimerCounter += 1
    }
    
    func hideTestPaths() {
        shouldDisplayTestPaths = false
        setNeedsDisplay()
    }
    
    func showTestPaths() {
        shouldDisplayTestPaths = true
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        if shouldDisplayTestPaths {
            UIColor.lightGray.setFill()
            for testPath in testPaths {
                testPath.fill()
            }
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
                nokPoints += 100
                log.warning("Not starting in expected area")
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let currentPoint = touch.location(in: self)
            
            if testPaths[expectedPathIndex].contains(currentPoint) {
                let numberOfCrrectDirections = testPaths[expectedPathIndex].numberOfCorrectDirections(lastPoint: lastPoint, currentPoint: currentPoint)
                if numberOfCrrectDirections == 0 {
                    okPoints -= 2
                } else {
                    okPoints += 1 * numberOfCrrectDirections
                }
                print("ok: \(okPoints)")
            } else if (expectedPathIndex + 1) < testPaths.count && testPaths[expectedPathIndex + 1].contains(currentPoint) {
                okPoints += 1
                expectedPathIndex += 1
                print("ok: \(okPoints) moving to next: \(expectedPathIndex)")
            } else {
                nokPoints += 2
                print("nok: \(nokPoints), expected: \(expectedPathIndex)")
            }
            
            drawLine(toPoint: currentPoint)
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        log.debug()
        if let touch = touches.first {
            if !expectedBeginAndEndAreas[expectedBeginAndEndAreasIndex].last!.contains(touch.location(in: self)) {
                log.warning("Not ending in expected area")
                nokPoints += 100
            }
        }
        if expectedBeginAndEndAreasIndex + 1 == expectedBeginAndEndAreas.count {
            delegate?.finishedGlyphWithResults(okPointsPercentage: Double(okPoints) / Double(nokPoints + okPoints))
        } else {
            expectedBeginAndEndAreasIndex += 1
        }
        
        print("ok: \(okPoints)")
        print("nok: \(nokPoints)")
    }
}

fileprivate extension GlyphView {
    
    func drawLine(toPoint: CGPoint) {
        path.addLine(to: toPoint)
        setNeedsDisplay()
    }
    
    func createExpectedBeginAndEndAreas() {
        log.debug()
        expectedBeginAndEndAreas = [[CGRect]]()
        
        for tuple in glyph.expectedBeginEndAreaCoordinates() {
            let firstCoordinate = tuple.0
            let lastCoordinate = tuple.1
            expectedBeginAndEndAreas.append([rows[firstCoordinate.x][firstCoordinate.y], rows[lastCoordinate.x][lastCoordinate.y]])
        }
    }
    
    func createPointArrayAndTestRectPaths() {
        log.debug()
        
        let linesCount = areaCoordinates.count - (1 + breakpointsIndexes.count)
        pointArray = [CGPoint](repeating: CGPoint.zero, count: linesCount * Const.inBetweenPointsCountForDrawing)
        testPaths = [TestPath]()
        
        var arrayIndex = 0
        
        for i in 0..<areaCoordinates.count - 1 {
            if breakpointsIndexes.contains(i + 1) {
                continue
            }
            let fromCoordinate = areaCoordinates[i]
            let toCoordinate = areaCoordinates[i + 1]
            let fromPoint = rows[fromCoordinate.x][fromCoordinate.y].center
            let toPoint = rows[toCoordinate.x][toCoordinate.y].center
            let xDiff = (fromPoint.x - toPoint.x) / CGFloat(Const.inBetweenPointsCountForDrawing)
            let yDiff = (fromPoint.y - toPoint.y) / CGFloat(Const.inBetweenPointsCountForDrawing)
            var currentX = fromPoint.x
            var currentY = fromPoint.y
            
            testPaths.append(TestPath(startPoint: fromPoint, goalPoint: toPoint, areaSize: rows[0][0].height))
            
            for _ in 0..<Const.inBetweenPointsCountForDrawing {
                pointArray[arrayIndex] = CGPoint(x: currentX, y: currentY)
                currentX -= xDiff
                currentY -= yDiff
                arrayIndex += 1
            }
        }
    }
}
