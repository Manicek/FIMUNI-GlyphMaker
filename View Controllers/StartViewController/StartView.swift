//
//  StartView.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 18/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

class StartView: UIView {

    struct Const {
        static let buttonSize: CGFloat = 80
        static let buttonInset: CGFloat = 20
    }
    
    private let backgroundView = BackgroundView()
    let spellsButton = DiamondButton("Train")
    let fightButton = DiamondButton("Battle")
    let creaturesButton = DiamondButton("Learn")
    let createButton = DiamondButton("Create")
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: CGRect())
        
        backgroundColor = .clear
        
        spellsButton.backgroundColor = .red
        creaturesButton.backgroundColor = .green
        fightButton.backgroundColor = .blue
        createButton.backgroundColor = .white
        
        addSubviewsAndSetupConstraints()
    }
}

private extension StartView {
    
    func addSubviewsAndSetupConstraints() {
        addSubviews(
            [
                backgroundView,
                spellsButton,
                creaturesButton,
                fightButton,
                createButton
            ]
        )
        
        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        spellsButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(Const.buttonSize)
            make.right.equalTo(self.snp.centerX).offset(-Const.buttonInset)
        }
        
        creaturesButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.width.equalTo(Const.buttonSize)
            make.bottom.equalTo(self.snp.centerY).offset(-Const.buttonInset)
        }
        
        fightButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(Const.buttonSize)
            make.left.equalTo(self.snp.centerX).offset(Const.buttonInset)
        }
        
        createButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.width.equalTo(Const.buttonSize)
            make.top.equalTo(self.snp.centerY).offset(Const.buttonInset)
        }
    }
}
