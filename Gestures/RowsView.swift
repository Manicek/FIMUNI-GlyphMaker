//
//  RowsView.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 13/04/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

class RowsView: UIView {

    var rows = [[CGRect]]()
    fileprivate var matrixAreas = [UIView]()
    
    func createRows() {
        if rows.count != 0 {
            log.debug("Matrix rows already created")
            return
        }
        let size = frame.width / CGFloat(AppConstants.matrixSize)
        
        for _ in 0..<AppConstants.matrixSize {
            rows.append([CGRect]())
        }
        
        for i in 0..<rows.count {
            let newFrame = CGRect(x: 0, y: CGFloat(i) * size, width: size, height: size)
            rows[i].append(newFrame)
            matrixAreas.append(MatrixArea(frame: newFrame))
            for j in 1..<AppConstants.matrixSize {
                let previousArea = rows[i][j - 1]
                let nextArea = CGRect(x: previousArea.maxX, y: previousArea.minY, width: size, height: size)
                rows[i].append(nextArea)
                matrixAreas.append(MatrixArea(frame: nextArea))
            }
        }
        addSubviews(matrixAreas)
    }
    
    func showMatrix() {
        for area in matrixAreas {
            area.isHidden = false
        }
    }
    
    func hideMatrix() {
        for area in matrixAreas {
            area.isHidden = true
        }
    }
}
