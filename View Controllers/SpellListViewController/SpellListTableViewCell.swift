//
//  SpellListTableViewCell.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 18/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

class SpellListTableViewCell: UITableViewCell {
    static let cellIdentifier = "SpellListTableViewCell"
    
    fileprivate let nameLabel = UILabel()
    fileprivate let damageLabel = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .gray
        
        nameLabel.font = UIFont.systemFont(ofSize: 15)
        nameLabel.textColor = .black
        
        damageLabel.font = UIFont.systemFont(ofSize: 15)
        damageLabel.textColor = .black
        
        addSubviewsAndSetupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with spell: Spell) {
        nameLabel.text = spell.name
        damageLabel.text = "Damage: " + String(format: "%.0f", spell.damage)
    }
}

fileprivate extension SpellListTableViewCell {
    
    func addSubviewsAndSetupConstraints() {
        addSubviews(
            [
                nameLabel,
                damageLabel
            ]
        )
        
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.left.equalToSuperview()
        }
        
        damageLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.snp.centerX)
        }
    }
}
