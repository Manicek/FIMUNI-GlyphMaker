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
    let remainingTimeView = RemainingTimeView()
    
    fileprivate let creatureImageView = UIImageView()
    
    let frontMatrixView = FrontMatrixView()
    let spellButton = SpellButton()
    
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
        
        addSubviewsAndSetupConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        rowsManager.createRowsForFrame(frontMatrixView.frame)
        
        frontMatrixView.rowsManager = rowsManager
        
        frontMatrixView.setup(with: Glyph.testGlyph)
    }
    
    func setup(with creature: Creature) {
        creatureImageView.image = creature.type.image
    }
}

fileprivate extension BattleView {
    
    func addSubviewsAndSetupConstraints() {
        addSubviews(
            [
                creatureImageView,
                frontMatrixView,
                healthBarView,
                remainingTimeView,
                spellButton
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
        
        spellButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(remainingTimeView.snp.top)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        healthBarView.snp.makeConstraints { (make) in
            make.bottom.equalTo(frontMatrixView.snp.top).offset(-5)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalToSuperview().multipliedBy(0.75)
        }
        
        remainingTimeView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(20)
            make.height.width.centerX.equalTo(healthBarView)
        }
    }
}
