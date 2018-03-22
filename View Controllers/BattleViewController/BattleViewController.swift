//
//  BattleViewController.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 22/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

class BattleViewController: UIViewController {
    
    fileprivate var battleView: BattleView {
        return view as! BattleView
    }
    
    fileprivate var currentGlyph = Glyph.testGlyph
    fileprivate var creature = Creature.testCreature
    
    func setup(with creature: Creature) {
        self.creature = creature
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        
        view = BattleView()
    }
}
