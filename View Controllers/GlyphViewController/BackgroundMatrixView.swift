//
//  GlyphView.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 14/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

protocol BackgroundMatrixViewDelegate: class {
    func sendRows(_ rows: [[CGRect]])
}

class BackgroundMatrixView: UIView {
    
    struct Const {
        static let matrixSize = 5
    }
    
    weak var delegate: BackgroundMatrixViewDelegate?
    
    fileprivate var rows = [[CGRect]]()
        
    init() {
        super.init(frame: CGRect())
        
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = self.frame.width / CGFloat(Const.matrixSize)
        
        for _ in 0..<Const.matrixSize {
            rows.append([CGRect]())
        }
        
        for i in 0..<rows.count {
            rows[i].append(CGRect(x: 0, y: CGFloat(i) * size, width: size, height: size))
            for j in 1..<Const.matrixSize {
                let previousArea = rows[i][j - 1]
                rows[i].append(CGRect(x: previousArea.maxX, y: previousArea.minY, width: size, height: size))
            }
        }
        
        delegate?.sendRows(rows)
    }
    
    override func draw(_ rect: CGRect) {
        for row in rows {
            for area in row {
                let areaPath = UIBezierPath(rect: area)
                UIColor(rgb: 45, 161, 216).setFill()
                areaPath.fill()
                UIColor.black.setStroke()
                areaPath.stroke()
            }
        }
    }
}
