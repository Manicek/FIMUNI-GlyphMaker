//
//  SpellButton.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 22/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

class SpellButton: UIButton {
    
    private(set) var spell: Spell!

    init(_ spell: Spell) {
        super.init(frame: CGRect())
        self.spell = spell
        
        setImage(spell.image, for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
