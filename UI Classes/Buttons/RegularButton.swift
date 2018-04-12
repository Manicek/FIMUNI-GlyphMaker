//
//  RegularButton.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 12/04/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

class RegularButton: UIButton {

    struct Const {        
        static let backgroundColor = UIColor.white
        static let titleAndBorderColor = UIColor.black
        static let borderWidth: CGFloat = 1
        static let cornerRadius: CGFloat = 8
        
        static let buttonLeftAndRightInset: CGFloat = 20
        static let buttonTopAndBottomInset: CGFloat = 12
    }
    
    init(_ title: String) {
        super.init(frame: CGRect())
        
        backgroundColor = Const.backgroundColor
        
        layer.borderWidth = Const.borderWidth
        layer.borderColor = Const.titleAndBorderColor.cgColor
        layer.cornerRadius = Const.cornerRadius
        
        titleLabel?.textAlignment = .center
        titleLabel?.font = .regularButtonFont
        setTitleColor(Const.titleAndBorderColor, for: .normal)
        setTitle(title, for: .normal)
        
        contentEdgeInsets = UIEdgeInsets(top: Const.buttonTopAndBottomInset, left: Const.buttonLeftAndRightInset, bottom: Const.buttonTopAndBottomInset, right: Const.buttonLeftAndRightInset)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
