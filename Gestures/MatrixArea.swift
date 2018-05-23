//
//  MatrixArea.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 06/04/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

class MatrixArea: UIView {
    
    private(set) var coordinate = AreaCoordinate(-1, -1)

    init(frame: CGRect, coordinate: AreaCoordinate) {
        super.init(frame: frame)
        
        self.coordinate = coordinate
        
        backgroundColor = .clear
        
        layer.borderWidth = 1
        layer.borderColor = GlyphMakerConstants.matrixAreaBorderColor.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateHighlighted(_ highlighted: Bool) {
        if highlighted {
            //backgroundColor = UIColor.white.withAlphaComponent(0.45)
        } else {
            backgroundColor = .clear
        }
    }
}
