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
    
    fileprivate var currentSpell: Spell? {
        didSet {
            guard let spell = currentSpell, let glyph = spell.glyph else {
                return
            }
            battleView.frontMatrixView.setup(with: glyph, forcefully: true)
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
        
        battleView.frontMatrixView.delegate = self
        
        battleView.setup(with: creature)
        
        if let results = SpellStore.getAllUnlockedSpells() {
            unlockedSpells = Array(results)
            for spell in unlockedSpells {
                let button = SpellButton(spell)
                button.addTarget(self, action: #selector(spellButtonTapped(_:)), for: .touchUpInside)
                battleView.spellButtonsStackView.addArrangedSubview(button)
                button.snp.remakeConstraints { (make) in
                    make.height.equalTo(battleView.spellButtonsStackView)
                    make.width.equalTo(button.snp.height)
                }
            }
        }
    }
    
    func spellButtonTapped(_ sender: SpellButton) {
        currentSpell = sender.spell
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

extension BattleViewController: FrontMatrixViewDelegate {
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
        
        battleView.frontMatrixView.clear()
    }
}

fileprivate extension BattleViewController {
    
    func restartRemainingTimeTimer() {
        remainingTimeTimer?.invalidate()
        remainingTimeTimer = nil
        remainingTimeTimerCounter = 0
        battleView.remainingTimeView.progress = 1
        remainingTimeTimer = Timer.scheduledTimer(timeInterval: Const.remainingTimeTimerInterval, target: self, selector: #selector(remainingTimeTimerUpdate), userInfo: nil, repeats: true)
    }
}
