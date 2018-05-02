//
//  RowsView.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 13/04/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

class RowsView: UIView {

    private(set) var rows = [[CGRect]]()
    private(set) var matrixAreas = [MatrixArea]()
    
    var path = UIBezierPath()
    
    init() {
        super.init(frame: CGRect())
        
        path = UIBezierPath.newPath()
        
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createRows() {
        if rows.count != 0 {
            log.debug("Matrix rows already created")
            return
        }
        let size = frame.width / CGFloat(AppConstants.matrixSize)
        
        for _ in 0..<AppConstants.matrixSize {
            rows.append([CGRect]())
        }
        
        for x in 0..<rows.count {
            let newFrame = CGRect(x: 0, y: CGFloat(x) * size, width: size, height: size)
            rows[x].append(newFrame)
            matrixAreas.append(MatrixArea(frame: newFrame, coordinate: AreaCoordinate(x, 0)))
            for y in 1..<AppConstants.matrixSize {
                let previousArea = rows[x][y - 1]
                let nextArea = CGRect(x: previousArea.maxX, y: previousArea.minY, width: size, height: size)
                rows[x].append(nextArea)
                matrixAreas.append(MatrixArea(frame: nextArea, coordinate: AreaCoordinate(x, y)))
            }
        }
        addSubviews(matrixAreas)
    }
    
    override func draw(_ rect: CGRect) {
        UIColor.red.setStroke()
        path.stroke()
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
