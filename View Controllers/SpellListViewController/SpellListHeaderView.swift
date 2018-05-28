//
//  SpellListHeaderView.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 18/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

class SpellListHeaderView: UIView {
    
    private let titleLabel = UILabel()

    init(forType type: DamageType) {
        super.init(frame: CGRect())
        
        backgroundColor = .white
        
        titleLabel.text = type.name
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
        titleLabel.textAlignment = .center
        titleLabel.textColor = type.color
        
        addSubviewsAndSetupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SpellListHeaderView {
    
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
