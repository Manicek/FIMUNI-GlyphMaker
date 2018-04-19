//
//  CreatureViewController.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 19/04/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

class CreatureViewController: UIViewController {
    
    private var creatureView: CreatureView {
        return view as! CreatureView
    }
    
    private var creature = Creature.testCreature

    override func loadView() {
        super.loadView()
        
        view = CreatureView(creature)
    }
    
    init(creature: Creature?) {
        super.init(nibName: nil, bundle: nil)
        if let creature = creature {
            self.creature = creature
        } else {
            self.creature = Creature.testCreature
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
