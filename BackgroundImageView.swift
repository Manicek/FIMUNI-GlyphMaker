//
//  BackgroundImageView.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 18/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

class BackgroundImageView: UIImageView {

    init() {
        super.init(frame: CGRect())
        
        image = #imageLiteral(resourceName: "beardedDragon1")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
