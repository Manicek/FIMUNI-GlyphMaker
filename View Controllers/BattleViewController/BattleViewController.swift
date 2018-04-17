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
    
    private var battleView: BattleView {
        return view as! BattleView
    }
    
    private var currentSpell: Spell? {
        didSet {
            guard let spell = currentSpell, let glyph = spell.glyph else {
                return
            }
            battleView.glyphView.setup(with: glyph, forcefully: true)
        }
    }
    private var creature = Creature.testCreature
    
    private var remainingTimeTimer: Timer?
    private var remainingTimeTimerCounter: TimeInterval = 0
    
    private var unlockedSpells = [Spell]()
    
    func setup(with creature: Creature) {
        self.creature = creature
    }
    
    override func loadView() {
        super.loadView()
        
        view = BattleView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        battleView.glyphView.delegate = self
        
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
    
    @objc func runButtonTapped() {
        stopRemainingTimeTimer()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func spellButtonTapped(_ sender: SpellButton) {
        currentSpell = sender.spell
    }
    
    @objc func remainingTimeTimerUpdate() {
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

extension BattleViewController: GlyphViewDelegate {
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
        
        battleView.glyphView.clear()
    }
}

private extension BattleViewController {
    
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
