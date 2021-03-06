//
//  Testswift
//  GlyphMaker
//
//  Created by Patrik Hora on 22/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

class TestPath: UIBezierPath {
    
    private var startPoint = CGPoint.zero
    private var goalPoint = CGPoint.zero

    init(startPoint: CGPoint, goalPoint: CGPoint, areaWidth: CGFloat, areaHeight: CGFloat) {
        super.init()
        
        self.startPoint = startPoint
        self.goalPoint = goalPoint
        
        lineWidth = GlyphMakerConstants.lineWidth
        
        var xOffset = GlyphMakerConstants.allowedOffsetMultiplier * areaWidth
        var yOffset = GlyphMakerConstants.allowedOffsetMultiplier * areaHeight

        let xDiff = fabs(startPoint.x - goalPoint.x)
        let yDiff = fabs(startPoint.y - goalPoint.y)
        
        if xDiff != 0 {
            xOffset *= CGFloat(2).squareRoot()
        }
        
        if yDiff != 0 {
            yOffset *= CGFloat(2).squareRoot()
        }
        
        let diffSum = xDiff + yDiff
        let xMultiplier = yDiff / diffSum * (startPoint.x - goalPoint.x > 0 ? -1 : 1)
        let yMultiplier = xDiff / diffSum * (startPoint.y - goalPoint.y < 0 ? -1 : 1)
                
        let startCorner1 = CGPoint(x: startPoint.x + xMultiplier * xOffset, y: startPoint.y + yMultiplier * yOffset)
        let startCorner2 = CGPoint(x: startPoint.x - xMultiplier * xOffset, y: startPoint.y - yMultiplier * yOffset)
        
        let goalCorner1 = CGPoint(x: goalPoint.x + xMultiplier * xOffset, y: goalPoint.y + yMultiplier * yOffset)
        let goalCorner2 = CGPoint(x: goalPoint.x - xMultiplier * xOffset, y: goalPoint.y - yMultiplier * yOffset)
        
        move(to: startCorner1)
        addLine(to: startCorner2)
        addLine(to: goalCorner2)
        addLine(to: goalCorner1)
        close()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfCorrectDirections(lastPoint: CGPoint, currentPoint: CGPoint) -> Int {
        var correctX = (startPoint.x == goalPoint.x)
        
        if !correctX {
            let xDiffLastGoal = fabs(goalPoint.x - lastPoint.x)
            let xDiffCurrentGoal = fabs(goalPoint.x - currentPoint.x)
            correctX = xDiffCurrentGoal < xDiffLastGoal
        }
        
        var correctY = (startPoint.x == goalPoint.x)
        
        if !correctY {
            let yDiffLastGoal = fabs(goalPoint.y - lastPoint.y)
            let yDiffCurrentGoal = fabs(goalPoint.y - currentPoint.y)
            correctY = yDiffCurrentGoal < yDiffLastGoal
        }
        
        return (correctX ? 1 : 0) + (correctY ? 1 : 0)
    }
}
