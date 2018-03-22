//
//  SpellListHeaderView.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 18/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

class SpellListHeaderView: UIView {
    
    fileprivate let titleLabel = UILabel()

    init(forType type: DamageType) {
        super.init(frame: CGRect())
        
        backgroundColor = .black
        
        titleLabel.text = type.name
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightHeavy)
        titleLabel.textAlignment = .center
        titleLabel.textColor = type.color
        
        addSubviewsAndSetupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate extension SpellListHeaderView {
    
    func addSubviewsAndSetupConstraints() {
        addSubviews(
            [
                titleLabel
            ]
        )
        
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
}
