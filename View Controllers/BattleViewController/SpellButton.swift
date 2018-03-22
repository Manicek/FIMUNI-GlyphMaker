//
//  SpellButton.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 22/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

class SpellButton: UIButton {

    init() {
        super.init(frame: CGRect())
        
        setImage(#imageLiteral(resourceName: "fireball"), for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
