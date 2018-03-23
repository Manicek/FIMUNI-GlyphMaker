//
//  BattleViewController.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 22/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

class BattleViewController: UIViewController {
    
    struct Const {
        static let timeForSpell: TimeInterval = 6
        static let remainingTimeTimerInterval: TimeInterval = 0.1
        static var progressUpdate: Float {
            return Float(remainingTimeTimerInterval / timeForSpell)
        }
    }
    
    fileprivate var battleView: BattleView {
        return view as! BattleView
    }
    
    fileprivate var currentGlyph = Glyph.testGlyph
    fileprivate var creature = Creature.testCreature
    
    fileprivate var remainingTimeTimer: Timer?
    fileprivate var remainingTimeTimerCounter: TimeInterval = 0
    
    func setup(with creature: Creature) {
        self.creature = creature
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        battleView.spellButton.addTarget(self, action: #selector(spellButtonTapped), for: .touchUpInside)
    }
    
    override func loadView() {
        super.loadView()
        
        view = BattleView()
    }
    
    func spellButtonTapped() {
        remainingTimeTimer?.invalidate()
        remainingTimeTimer = nil
        remainingTimeTimerCounter = 0
        battleView.remainingTimeView.progress = 1
        remainingTimeTimer = Timer.scheduledTimer(timeInterval: Const.remainingTimeTimerInterval, target: self, selector: #selector(remainingTimeTimerUpdate), userInfo: nil, repeats: true)
    }
    
    func remainingTimeTimerUpdate() {
        if remainingTimeTimerCounter == Const.timeForSpell {
            remainingTimeTimer?.invalidate()
            remainingTimeTimer = nil
            remainingTimeTimerCounter = 0
            return
        }
        battleView.remainingTimeView.progress -= Const.progressUpdate
        remainingTimeTimerCounter += Const.remainingTimeTimerInterval
    }
}
