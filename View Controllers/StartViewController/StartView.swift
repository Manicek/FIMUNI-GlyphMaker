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
        static let buttonSize: CGFloat = 65
        static let buttonInset: CGFloat = 10
    }
    
    fileprivate let backgroundImageView = BackgroundImageView()
    let schoolButton = UIButton()
    let fightButton = UIButton()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        super.init(frame: CGRect())
        
        backgroundColor = .clear
        
        schoolButton.setTitle("School", for: .normal)
        schoolButton.setTitleColor(.black, for: .normal)
        schoolButton.backgroundColor = .green
        schoolButton.layer.cornerRadius = Const.buttonSize / 2
        
        fightButton.setTitle("Fight", for: .normal)
        fightButton.setTitleColor(.black, for: .normal)
        fightButton.backgroundColor = .blue
        fightButton.layer.cornerRadius = Const.buttonSize / 2
        
        addSubviewsAndSetupConstraints()
    }
}

fileprivate extension StartView {
    
    func addSubviewsAndSetupConstraints() {
        addSubviews(
            [
                backgroundImageView,
                schoolButton,
                fightButton
            ]
        )
        
        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        schoolButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(Const.buttonSize)
            make.right.equalTo(self.snp.centerX).offset(-Const.buttonInset)
        }
        
        fightButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(Const.buttonSize)
            make.left.equalTo(self.snp.centerX).offset(Const.buttonInset)
        }
    }
}
