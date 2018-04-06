//
//  MatrixArea.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 06/04/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

class MatrixArea: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.green.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
