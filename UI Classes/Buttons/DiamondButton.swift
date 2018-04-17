//
//  DiamondButton.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 12/04/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

class DiamondButton: UIButton {

    struct Const {
        static let backgroundColor = UIColor.white
        static let titleAndBorderColor = UIColor.black
        static let borderWidth: CGFloat = 1
        
        static let buttonLeftAndRightInset: CGFloat = 0
        static let buttonTopAndBottomInset: CGFloat = 0
    }
    
    private let customTitleLabel = UILabel()
    
    init(_ title: String) {
        super.init(frame: CGRect())
        
        backgroundColor = Const.backgroundColor
        
        layer.borderWidth = Const.borderWidth
        layer.borderColor = Const.titleAndBorderColor.cgColor
        
        customTitleLabel.textAlignment = .center
        customTitleLabel.font = .regularButtonFont
        setTitleColor(Const.titleAndBorderColor, for: .normal)
        setTitle(title, for: .normal)
        
        contentEdgeInsets = UIEdgeInsets(top: Const.buttonTopAndBottomInset, left: Const.buttonLeftAndRightInset, bottom: Const.buttonTopAndBottomInset, right: Const.buttonLeftAndRightInset)
        
        addSubview(customTitleLabel)
        
        customTitleLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
        customTitleLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 4)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setTitle(_ title: String?, for state: UIControlState) {
        customTitleLabel.text = title
    }
    
    override func setTitleColor(_ color: UIColor?, for state: UIControlState) {
        customTitleLabel.textColor = color
    }
}
