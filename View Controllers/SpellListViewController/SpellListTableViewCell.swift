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
    
    private let nameLabel = UILabel()
    private let damageLabel = UILabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .gray
        
        layer.cornerRadius = 8
        
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

private extension SpellListTableViewCell {
    
    func addSubviewsAndSetupConstraints() {
        addSubviews(
            [
                nameLabel,
                damageLabel
            ]
        )
        
        nameLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
        }
        
        damageLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(self.snp.centerX)
        }
    }
}
