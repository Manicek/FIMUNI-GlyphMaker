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
        
        path = UIBezierPath()
        path.lineWidth = 6
        
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
        let width = frame.width / CGFloat(GlyphMakerConstants.numberOfColumns)
        let height = frame.height / CGFloat(GlyphMakerConstants.numberOfRows)
        
        for _ in 0..<GlyphMakerConstants.numberOfRows {
            rows.append([CGRect]())
        }
        
        for x in 0..<rows.count {
            let newFrame = CGRect(x: 0, y: CGFloat(x) * height, width: width, height: height)
            rows[x].append(newFrame)
            matrixAreas.append(MatrixArea(frame: newFrame, coordinate: AreaCoordinate(x, 0)))
            for y in 1..<GlyphMakerConstants.numberOfColumns {
                let previousArea = rows[x][y - 1]
                let nextArea = CGRect(x: previousArea.maxX, y: previousArea.minY, width: width, height: height)
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
