//
//  BattleView.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 22/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

class BattleView: UIView {
    
    fileprivate let rowsManager = RowsManager()

    fileprivate let healthBarView = HealthBarView()
    fileprivate let healthLabel = HealthLabel()
    let remainingTimeView = RemainingTimeView()
    
    fileprivate let creatureImageView = UIImageView()
    
    let frontMatrixView = FrontMatrixView()
    let spellButtonsStackView = UIStackView()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: CGRect())
        
        backgroundColor = .white
            
        healthBarView.progress = 1
        
        remainingTimeView.progress = 1
        
        frontMatrixView.layer.borderWidth = 1
        frontMatrixView.layer.borderColor = UIColor.black.cgColor
        
        spellButtonsStackView.spacing = 10
        spellButtonsStackView.axis = .horizontal
        spellButtonsStackView.distribution = .equalSpacing
        spellButtonsStackView.alignment = .center
        
        addSubviewsAndSetupConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        rowsManager.createRowsForFrame(frontMatrixView.frame)
        
        frontMatrixView.rowsManager = rowsManager
    }
    
    func setup(with creature: Creature) {
        creatureImageView.image = creature.type.image
        healthLabel.healthValue = creature.maxHealth
    }
    
    func setRemainingHealth(current: Double, max: Double) {
        healthBarView.progress = Float(current / max)
        healthLabel.healthValue = current
    }
}

fileprivate extension BattleView {
    
    func addSubviewsAndSetupConstraints() {
        addSubviews(
            [
                creatureImageView,
                frontMatrixView,
                healthBarView,
                healthLabel,
                remainingTimeView,
                spellButtonsStackView
            ]
        )
        
        frontMatrixView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(frontMatrixView.snp.width)
        }
        
        creatureImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(frontMatrixView)
        }
        
        spellButtonsStackView.snp.makeConstraints { (make) in
            make.bottom.equalTo(remainingTimeView.snp.top)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(remainingTimeView)
        }
        
        healthBarView.snp.makeConstraints { (make) in
            make.bottom.equalTo(frontMatrixView.snp.top).offset(-5)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalToSuperview().multipliedBy(0.75)
        }
        
        healthLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(healthBarView.snp.top).offset(-5)
            make.centerX.equalTo(healthBarView)
        }
        
        remainingTimeView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(20)
            make.height.width.centerX.equalTo(healthBarView)
        }
    }
}
