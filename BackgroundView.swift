//
//  BackgroundView.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 18/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

class BackgroundView: UIView {

    init() {
        super.init(frame: CGRect())
        //image = UIImage()
        //image = #imageLiteral(resourceName: "beardedDragon1")
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
