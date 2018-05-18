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
    
    weak var delegate: GlyphViewDelegate?
    
    private var glyph = Glyph.testGlyph
    
    private var lastPoint = CGPoint.zero
    
    private var testPaths = [TestPath]()
    
    private var expectedPathIndex = 0
    private var expectedBeginAndEndAreasIndex = 0
    private var expectedBeginAndEndAreas = [[CGRect]]()
    
    private var okPoints = 0
    private var nokPoints = 0
    
    private var drawingTimer: Timer?
    private var drawingTimerCounter = 0
    private var pointArray = [CGPoint]()
    
    private var isAlreadySetup = false
    private var shouldDisplayTestPaths = true
    
    public var shouldDrawUsersTouches = true
    
    override init() {
        super.init()
        
        isUserInteractionEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with glyph: Glyph, forcefully: Bool = false) {
         if isAlreadySetup && !forcefully {
            return
        }
        isAlreadySetup = true
        
        self.glyph = glyph
        
        createExpectedBeginAndEndAreas()
        createPointArrayAndTestRectPaths()
        
        isUserInteractionEnabled = true
        setNeedsDisplay()
    }
    
    func clear() {
        drawingTimer?.invalidate()
        drawingTimer = nil
        drawingTimerCounter = 0
        path.removeAllPoints()
        okPoints = 0
        nokPoints = 0
        expectedBeginAndEndAreasIndex = 0
        expectedPathIndex = 0
        setNeedsDisplay()
    }
    
    func drawGlyph() {
        drawingTimer?.invalidate()
        drawingTimer = nil
        drawingTimerCounter = 0
        
        path.removeAllPoints()
        
        drawingTimer = Timer.scheduledTimer(timeInterval: GlyphMakerConstants.drawingTime, target: self, selector: #selector(drawingTimerUpdate), userInfo: nil, repeats: true)
    }
    
    @objc func drawingTimerUpdate() {
        if drawingTimerCounter == pointArray.count {
            drawingTimer?.invalidate()
            drawingTimer = nil
            return
        }
        
        let shouldMove = drawingTimerCounter % GlyphMakerConstants.inBetweenPointsCountForDrawing == 0 && glyph.breakpointsIndexes.contains((drawingTimerCounter / GlyphMakerConstants.inBetweenPointsCountForDrawing) + 1)
        
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
            GlyphMakerConstants.testPathColor.setFill()
            for testPath in testPaths {
                testPath.fill(with: .normal, alpha: GlyphMakerConstants.testPathOpacity)
            }
        }

        GlyphMakerConstants.lineColor.setStroke()
        path.stroke()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let firstPoint = touch.location(in: self)
            lastPoint = firstPoint
            path.move(to: firstPoint)
            
            if !expectedBeginAndEndAreas[expectedBeginAndEndAreasIndex].first!.contains(firstPoint) {
                nokPoints += GlyphMakerConstants.wrongBeginOrEndAreaPenalty
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let currentPoint = touch.location(in: self)
            
            if testPaths[expectedPathIndex].contains(currentPoint) {
                let numberOfCorrectDirections = testPaths[expectedPathIndex].numberOfCorrectDirections(lastPoint: lastPoint, currentPoint: currentPoint)
                if numberOfCorrectDirections == 0 {
                    okPoints -= 2
                } else {
                    okPoints += numberOfCorrectDirections
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
            
            path.addLine(to: currentPoint)
            
            if shouldDrawUsersTouches {
                setNeedsDisplay()
            }

            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if !expectedBeginAndEndAreas[expectedBeginAndEndAreasIndex].last!.contains(touch.location(in: self)) {
                nokPoints += GlyphMakerConstants.wrongBeginOrEndAreaPenalty
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

private extension GlyphView {
    
    func createExpectedBeginAndEndAreas() {
        expectedBeginAndEndAreas = [[CGRect]]()
        
        for tuple in glyph.expectedBeginEndAreaCoordinates() {
            let firstCoordinate = tuple.0
            let lastCoordinate = tuple.1
            expectedBeginAndEndAreas.append([rows[firstCoordinate.x][firstCoordinate.y], rows[lastCoordinate.x][lastCoordinate.y]])
        }
    }
    
    func createPointArrayAndTestRectPaths() {
        let linesCount = glyph.areasCoordinates.count - (1 + glyph.breakpointsIndexes.count)
        pointArray = [CGPoint](repeating: CGPoint.zero, count: linesCount * GlyphMakerConstants.inBetweenPointsCountForDrawing)
        testPaths = [TestPath]()
        
        var arrayIndex = 0
        
        for i in 0..<glyph.areasCoordinates.count - 1 {
            if glyph.breakpointsIndexes.contains(i + 1) {
                continue
            }
            let fromCoordinate = glyph.areasCoordinates[i]
            let toCoordinate = glyph.areasCoordinates[i + 1]
            let fromPoint = rows[fromCoordinate.x][fromCoordinate.y].center
            let toPoint = rows[toCoordinate.x][toCoordinate.y].center
            let xDiff = (fromPoint.x - toPoint.x) / CGFloat(GlyphMakerConstants.inBetweenPointsCountForDrawing)
            let yDiff = (fromPoint.y - toPoint.y) / CGFloat(GlyphMakerConstants.inBetweenPointsCountForDrawing)
            var currentX = fromPoint.x
            var currentY = fromPoint.y
            
            testPaths.append(TestPath(startPoint: fromPoint, goalPoint: toPoint, areaWidth: rows[0][0].width, areaHeight: rows[0][0].height))
            
            for _ in 0..<GlyphMakerConstants.inBetweenPointsCountForDrawing {
                pointArray[arrayIndex] = CGPoint(x: currentX, y: currentY)
                currentX -= xDiff
                currentY -= yDiff
                arrayIndex += 1
            }
        }
    }
}
