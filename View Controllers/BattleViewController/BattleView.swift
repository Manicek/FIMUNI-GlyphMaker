//
//  BattleView.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 22/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

class BattleView: UIView {
    
    private let healthBarView = HealthBarView()
    private let healthLabel = HealthLabel()
    let remainingTimeView = RemainingTimeView()
    
    private let creatureImageView = UIImageView()
    
    let runButton = RegularButton("Run")
    
    let glyphView = GlyphView()
    private let spellButtonsStackView = UIStackView()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: CGRect())
        
        backgroundColor = .white
            
        healthBarView.progress = 1
        
        remainingTimeView.progress = 1
        
        spellButtonsStackView.spacing = 10
        spellButtonsStackView.axis = .horizontal
        spellButtonsStackView.distribution = .equalSpacing
        spellButtonsStackView.alignment = .center
        
        addSubviewsAndSetupConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        glyphView.createRows()
        glyphView.hideMatrix()
    }
    
    func setup(with creature: Creature) {
        creatureImageView.image = creature.type.image
        healthLabel.healthValue = creature.maxHealth
    }
    
    func setRemainingHealth(current: Double, max: Double) {
        healthBarView.progress = Float(current / max)
        healthLabel.healthValue = current
    }
    
    func addSpellButton(_ button: SpellButton) {
        spellButtonsStackView.addArrangedSubview(button)
        button.snp.remakeConstraints { (make) in
            make.height.equalTo(spellButtonsStackView)
            make.width.equalTo(button.snp.height)
        }
    }
}

private extension BattleView {
    
    func addSubviewsAndSetupConstraints() {
        addSubviews(
            [
                creatureImageView,
                glyphView,
                healthBarView,
                healthLabel,
                runButton,
                remainingTimeView,
                spellButtonsStackView
            ]
        )
        
        glyphView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(glyphView.snp.width)
        }
        
        creatureImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(glyphView)
        }
        
        spellButtonsStackView.snp.makeConstraints { (make) in
            make.bottom.equalTo(remainingTimeView.snp.top).offset(-5)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
        
        healthBarView.snp.makeConstraints { (make) in
            make.bottom.equalTo(glyphView.snp.top).offset(-5)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalToSuperview().multipliedBy(0.75)
        }
        
        healthLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(healthBarView.snp.top).offset(-5)
            make.centerX.equalTo(healthBarView)
        }
        
        runButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(healthLabel.snp.top).offset(-10)
            make.centerX.equalToSuperview()
        }
        
        remainingTimeView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(20)
            make.height.width.centerX.equalTo(healthBarView)
        }
    }
}
