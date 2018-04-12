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
        static let timeForFight: TimeInterval = 15
        static let remainingTimeTimerInterval: TimeInterval = 0.1
        static let progressUpdate = Float(remainingTimeTimerInterval / timeForFight)
    }
    
    fileprivate var battleView: BattleView {
        return view as! BattleView
    }
    
    fileprivate var currentSpell: Spell? {
        didSet {
            guard let spell = currentSpell, let glyph = spell.glyph else {
                return
            }
            battleView.matrixView.setup(with: glyph, forcefully: true)
        }
    }
    fileprivate var creature = Creature.testCreature
    
    fileprivate var remainingTimeTimer: Timer?
    fileprivate var remainingTimeTimerCounter: TimeInterval = 0
    
    fileprivate var unlockedSpells = [Spell]()
    
    func setup(with creature: Creature) {
        self.creature = creature
    }
    
    override func loadView() {
        super.loadView()
        
        view = BattleView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        battleView.matrixView.delegate = self
        
        creature = Creature.getRandomCreature()
        battleView.setup(with: creature)
        
        if let results = SpellStore.getAllUnlockedSpells() {
            unlockedSpells = Array(results)
            for spell in unlockedSpells {
                let button = SpellButton(spell)
                button.addTarget(self, action: #selector(spellButtonTapped(_:)), for: .touchUpInside)
                battleView.addSpellButton(button)
            }
        }
        
        battleView.runButton.addTarget(self, action: #selector(runButtonTapped), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startRemainingTimeTimer()
    }
    
    func runButtonTapped() {
        stopRemainingTimeTimer()
        dismiss(animated: true, completion: nil)
    }
    
    func spellButtonTapped(_ sender: SpellButton) {
        currentSpell = sender.spell
    }
    
    func remainingTimeTimerUpdate() {
        if remainingTimeTimerCounter >= Const.timeForFight {
            if creature.alive {
                showBasicAlert(message: "You got rekt", title: "Dead")
            } else{
                showBasicAlert(message: "You are a winrar", title: "GG")
            }
            stopRemainingTimeTimer()
            return
        }
        battleView.remainingTimeView.progress -= Const.progressUpdate
        remainingTimeTimerCounter += Const.remainingTimeTimerInterval
    }
}

extension BattleViewController: MatrixViewDelegate {
    func finishedGlyphWithResults(okPointsPercentage: Double) {
        log.debug("ratio: \(100 * okPointsPercentage)")
        
        if okPointsPercentage > AppConstants.minimumPercentageToPass {
            if let spell = currentSpell {
                let damage = spell.damage * okPointsPercentage
                let dealtDamage = creature.receiveDamage(damage, ofType: spell.damageType)
                showBasicAlert(message: String(format: "You dealt %.0f damage, the creature resisted %.0f", dealtDamage, damage - dealtDamage), title: "Success!")
                battleView.setRemainingHealth(current: creature.health, max: creature.maxHealth)
            }
        } else {
            showBasicAlert(message: "You dun goofd", title: "Failure!")
        }
        
        battleView.matrixView.clear()
    }
}

fileprivate extension BattleViewController {
    
    func startRemainingTimeTimer() {
        remainingTimeTimerCounter = 0
        battleView.remainingTimeView.progress = 1
        remainingTimeTimer = Timer.scheduledTimer(timeInterval: Const.remainingTimeTimerInterval, target: self, selector: #selector(remainingTimeTimerUpdate), userInfo: nil, repeats: true)
    }
    
    func stopRemainingTimeTimer() {
        remainingTimeTimer?.invalidate()
        remainingTimeTimer = nil
    }
}
