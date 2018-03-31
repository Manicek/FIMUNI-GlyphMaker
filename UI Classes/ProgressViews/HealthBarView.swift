//
//  HealthBarView.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 22/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

class HealthBarView: UIProgressView {

    struct Const {
        static let trackTintColor = UIColor.black
        static let progressTintColor = UIColor.red
    }
    
    init() {
        super.init(frame: CGRect())
        
        trackTintColor = Const.trackTintColor
        progressTintColor = Const.progressTintColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
