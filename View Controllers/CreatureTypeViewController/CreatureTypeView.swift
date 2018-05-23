//
//  CreatureView.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 19/04/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

class CreatureTypeView: UIView {

    private let backgroundImageView = BackgroundImageView()
    private let titleLabel = UILabel()
    private let imageView = UIImageView()
    private let descriptionLabel = UILabel()
    private let fireResistanceLabel = UILabel()
    private let coldResistanceLabel = UILabel()
    private let physicalResistanceLabel = UILabel()
    
    init(_ creatureType: CreatureType) {
        super.init(frame: CGRect())
        
        titleLabel.text = creatureType.name
        titleLabel.textColor = .white
        
        imageView.image = creatureType.image
        
        descriptionLabel.text = creatureType.description
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = .white
        
        fireResistanceLabel.text = String(format: "Fire resistance: %.0f %%", 100 * creatureType.fireResistance)
        coldResistanceLabel.text = String(format: "Cold resistance: %.0f %%", 100 * creatureType.coldResistance)
        physicalResistanceLabel.text = String(format: "Physical resistance: %.0f %%", 100 * creatureType.physicalResistance)
        
        fireResistanceLabel.textColor = .white
        coldResistanceLabel.textColor = .white
        physicalResistanceLabel.textColor = .white
        
        addSubviewsAndSetupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CreatureTypeView {
    
    func addSubviewsAndSetupConstraints() {
        addSubviews(
            [
                backgroundImageView,
                titleLabel,
                imageView,
                descriptionLabel,
                fireResistanceLabel,
                coldResistanceLabel,
                physicalResistanceLabel
            ]
        )
        
        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(60)
        }
        
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.equalTo(imageView.snp.width)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.top.equalTo(imageView.snp.bottom).offset(10)
        }
        
        fireResistanceLabel.snp.makeConstraints { (make) in
            make.left.width.equalTo(descriptionLabel)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
        }
        
        coldResistanceLabel.snp.makeConstraints { (make) in
            make.left.width.equalTo(descriptionLabel)
            make.top.equalTo(fireResistanceLabel.snp.bottom).offset(5)
        }
        
        physicalResistanceLabel.snp.makeConstraints { (make) in
            make.left.width.equalTo(descriptionLabel)
            make.top.equalTo(coldResistanceLabel.snp.bottom).offset(5)
        }
    }
}


















