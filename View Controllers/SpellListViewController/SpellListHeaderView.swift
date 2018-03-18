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
        
        addSubviewsAndSetupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
