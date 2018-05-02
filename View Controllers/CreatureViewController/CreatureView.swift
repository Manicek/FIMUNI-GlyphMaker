//
//  CreatureView.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 19/04/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

class CreatureView: UIView {

    init(_ creature: RealmCreature) {
        super.init(frame: CGRect())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
