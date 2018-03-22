//
//  GlyphView.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 14/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

class BackgroundMatrixView: UIView {
    
    weak var rowsManager: RowsManager?
        
    init() {
        super.init(frame: CGRect())
        
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        guard let rows = rowsManager?.rows else {
            super.draw(rect)
            return
        }
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
