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

    init(startPoint: CGPoint, goalPoint: CGPoint, areaSize: CGFloat) {
        super.init()
        
        self.startPoint = startPoint
        self.goalPoint = goalPoint
        
        lineWidth = AppConstants.lineWidth
        
        var offset = AppConstants.allowedOffsetMultiplier * areaSize
        
        let xDiff = fabs(startPoint.x - goalPoint.x)
        let yDiff = fabs(startPoint.y - goalPoint.y)
        
        if xDiff != 1 && yDiff != 1 {
            offset *= CGFloat(2).squareRoot()
        }
        
        let diffSum = xDiff + yDiff
        let xMultiplier = yDiff / diffSum * (startPoint.x - goalPoint.x > 0 ? -1 : 1)
        let yMultiplier = xDiff / diffSum * (startPoint.y - goalPoint.y < 0 ? -1 : 1)
        
        if xMultiplier != 1 && yMultiplier != 1 {
            offset *= CGFloat(2).squareRoot()
        }
        
        let firstCorner1 = CGPoint(x: startPoint.x + xMultiplier * offset, y: startPoint.y + yMultiplier * offset)
        let firstCorner2 = CGPoint(x: startPoint.x - xMultiplier * offset, y: startPoint.y - yMultiplier * offset)
        
        let secondCorner1 = CGPoint(x: goalPoint.x + xMultiplier * offset, y: goalPoint.y + yMultiplier * offset)
        let secondCorner2 = CGPoint(x: goalPoint.x - xMultiplier * offset, y: goalPoint.y - yMultiplier * offset)
        
        move(to: firstCorner1)
        addLine(to: firstCorner2)
        addLine(to: secondCorner2)
        addLine(to: secondCorner1)
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
