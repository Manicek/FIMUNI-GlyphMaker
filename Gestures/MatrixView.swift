//
//  MatrixView.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 15/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

protocol MatrixViewDelegate: class {
    func finishedGlyphWithResults(okPointsPercentage: Double)
}

class MatrixView: UIView {
    
    struct Const {
        static let drawingTime: TimeInterval = 0.05
        static let inBetweenPointsCount = 20
    }
    
    var rows = [[CGRect]]()
    
    weak var delegate: MatrixViewDelegate?
    
    fileprivate var glyph = Glyph.testGlyph
    
    fileprivate var path = UIBezierPath()
    fileprivate var lastPoint = CGPoint.zero
    
    fileprivate var testPaths = [TestPath]()
    
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
    fileprivate var shouldDisplayTestPaths = true
    
    init() {
        super.init(frame: CGRect())
        
        recreatePath()
        
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createRows() {
        let size = frame.width / CGFloat(AppConstants.matrixSize)
        
        for _ in 0..<AppConstants.matrixSize {
            rows.append([CGRect]())
        }
        
        for i in 0..<rows.count {
            rows[i].append(CGRect(x: 0, y: CGFloat(i) * size, width: size, height: size))
            for j in 1..<AppConstants.matrixSize {
                let previousArea = rows[i][j - 1]
                rows[i].append(CGRect(x: previousArea.maxX, y: previousArea.minY, width: size, height: size))
            }
        }
    }
    
    func setup(with glyph: Glyph, forcefully: Bool = false) {
        log.debug()
        if isAlreadySetup && !forcefully {
            return
        }
        isAlreadySetup = true
        
        self.glyph = glyph
        
        areaIndexTuples = Array(glyph.areasIndexes)
        breakpointsIndexes = Array(glyph.breakpointsIndexes)
        
        createExpectedBeginAndEndAreas()
        createPointArrayAndTestRectPaths()
        
        print("pointArray count: \(pointArray.count)")
        print("breakpointIndex: \(breakpointsIndexes)")
        print("areasIndexes count: \(areaIndexTuples.count)")
        print("testPaths count: \(testPaths.count)")
        print("expectedBeginAndEndAreas count: \(expectedBeginAndEndAreas.count)")
        
        setNeedsDisplay()
    }
    
    func clear() {
        log.debug()
        drawingTimer?.invalidate()
        drawingTimer = nil
        drawingTimerCounter = 0
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
                log.warning("Not starting in begin area")
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

fileprivate extension MatrixView {
    
    func drawLine(toPoint: CGPoint) {
        path.addLine(to: toPoint)
        setNeedsDisplay()
    }
    
    func recreatePath() {
        log.debug()
        path = UIBezierPath()
        path.lineWidth = AppConstants.lineWidth
    }
    
    func createExpectedBeginAndEndAreas() {
        log.debug()
        expectedBeginAndEndAreas = [[CGRect]]()
        
        for tupleDuo in glyph.expectedBegindEndAreaIndexTuples() {
            let firstTuple = tupleDuo.first!
            let lastTuple = tupleDuo.last!
            expectedBeginAndEndAreas.append([rows[firstTuple.x][firstTuple.y], rows[lastTuple.x][lastTuple.y]])
        }
    }
    
    func createPointArrayAndTestRectPaths() {
        log.debug()
        
        let linesCount = areaIndexTuples.count - (1 + breakpointsIndexes.count)
        pointArray = [CGPoint](repeating: CGPoint.zero, count: linesCount * Const.inBetweenPointsCount)
        testPaths = [TestPath]()
        
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
            
            testPaths.append(TestPath(startPoint: fromPoint, goalPoint: toPoint, areaSize: rows[0][0].height))
            
            for _ in 0..<Const.inBetweenPointsCount {
                pointArray[arrayIndex] = CGPoint(x: currentX, y: currentY)
                currentX -= xDiff
                currentY -= yDiff
                arrayIndex += 1
            }
        }
    }
}
