//
//  RemainingTimeView.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 22/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

class RemainingTimeView: UIProgressView {

    struct Const {
        static let trackTintColor = UIColor.white.withAlphaComponent(0.3)
        static let progressTintColor = UIColor.blue
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
