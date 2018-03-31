//
//  HealthLabel.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 30/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

class HealthLabel: BaseLabel {
    
    var healthValue: Double? {
        didSet {
            guard let healthValue = healthValue else {
                return
            }
            text = String(format: "HP: %.0f", healthValue)
        }
    }
    
    init() {
        super.init(textAlignment: .center, font: UIFont.systemFont(ofSize: 15), textColor: .black)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
