//
//  CreatureListTableViewCell.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 17/04/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

class CreatureListTableViewCell: UITableViewCell {
    static let cellIdentifier = "CreatureListTableViewCell"
    
    private let nameLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .gray
        
        layer.cornerRadius = 8
        
        nameLabel.font = UIFont.systemFont(ofSize: 15)
        nameLabel.textColor = .black
        
        addSubviewsAndSetupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with creatureType: CreatureType) {
        nameLabel.text = creatureType.name
    }
}

private extension CreatureListTableViewCell {
    
    func addSubviewsAndSetupConstraints() {
        addSubviews(
            [
                nameLabel
            ]
        )
        
        nameLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
}
