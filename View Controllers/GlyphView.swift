//
//  GlyphView.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 15/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import SnapKit

class GlyphView: UIView {
    
    fileprivate let backgroundMatrixView = BackgroundMatrixView()
    fileprivate let frontMatrixView = FrontMatrixView()

    init() {
        super.init(frame: CGRect())
        
        backgroundColor = .clear
        
        backgroundMatrixView.delegate = self
        
        addSubviewsAndSetupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension GlyphView: BackgroundMatrixViewDelegate {
    func sendRows(_ rows: [[CGRect]]) {
        frontMatrixView.rows = rows
    }
}

fileprivate extension GlyphView {
    
    func addSubviewsAndSetupConstraints() {
        addSubviews(
            [
                backgroundMatrixView,
                frontMatrixView
            ]
        )
        
        
        backgroundMatrixView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        frontMatrixView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
