//
//  BaseLabel.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 30/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

class BaseLabel: UILabel {
    
    init(textAlignment: NSTextAlignment, font: UIFont, textColor: UIColor = .mainText) {
        super.init(frame: CGRect())
        
        self.textAlignment = textAlignment
        self.font = font
        self.textColor = textColor
        
        baselineAdjustment = .alignCenters
        lineBreakMode = .byWordWrapping
        numberOfLines = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
