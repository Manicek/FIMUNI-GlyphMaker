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
    fileprivate let remainingTimeView = RemainingTimeView()
    
    fileprivate let frontMatrixView = FrontMatrixView()
    fileprivate let spellButton = SpellButton()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: CGRect())
        
        backgroundColor = .white
    
        spellButton.addTarget(self, action: #selector(spellButtonTapped), for: .touchUpInside)
        
        healthBarView.progress = 1
        remainingTimeView.progress = 1
        
        addSubviewsAndSetupConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        rowsManager.createRowsForFrame(frontMatrixView.frame)
        
        frontMatrixView.rowsManager = rowsManager
        
        frontMatrixView.setup(with: Glyph.testGlyph)
    }
    
    func spellButtonTapped() {
        
    }
}

fileprivate extension BattleView {
    
    func addSubviewsAndSetupConstraints() {
        addSubviews(
            [
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
        
        spellButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(20)
            make.right.equalToSuperview().inset(20)
            make.width.height.equalTo(50)
        }
        
        healthBarView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalToSuperview().multipliedBy(0.75)
        }
        
        remainingTimeView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(20)
            make.right.equalTo(spellButton.snp.left).offset(-20)
            make.height.equalTo(20)
            make.width.equalToSuperview().multipliedBy(0.6)
        }
    }
}
