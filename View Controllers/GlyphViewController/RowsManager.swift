//
//  RowsManager.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 20/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

class RowsManager: NSObject {
    
    var rows = [[CGRect]]()
    
    func createRowsForFrame(_ frame: CGRect) {
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
}
