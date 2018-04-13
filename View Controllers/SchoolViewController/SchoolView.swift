//
//  SchoolView.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 15/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import SnapKit

class SchoolView: UIView {
    
    fileprivate let backgroundImageView = BackgroundImageView()
    fileprivate let matrixView = MatrixView()
    fileprivate let clearButton = RegularButton("Clear")
    fileprivate let drawGlyphButton = RegularButton("Draw")
    fileprivate let showHideTestPathsButton = ShowHideButton(status: .hide, what: "paths")
    fileprivate let showHideMatrixButton = ShowHideButton(status: .hide, what: "matrix")
    
    fileprivate var glyph: Glyph!

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(_ glyph: Glyph) {
        super.init(frame: CGRect())
        
        self.glyph = glyph

        backgroundColor = .clear
                
        clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        drawGlyphButton.addTarget(self, action: #selector(drawGlyphButtonTapped), for: .touchUpInside)
        showHideTestPathsButton.addTarget(self, action: #selector(showHideTestPathsButtonTapped), for: .touchUpInside)
        showHideMatrixButton.addTarget(self, action: #selector(showHideMatrixButtonTapped), for: .touchUpInside)
        
        addSubviewsAndSetupConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        matrixView.createRows()
        matrixView.setup(with: glyph)
    }
    
    func clearButtonTapped() {
        matrixView.clear()
    }

    func drawGlyphButtonTapped() {
        matrixView.drawGlyph()
    }
    
    func showHideTestPathsButtonTapped() {
        
    }
    
    func showHideMatrixButtonTapped() {
        
    }
}

fileprivate extension SchoolView {
    
    func addSubviewsAndSetupConstraints() {
        addSubviews(
            [
                backgroundImageView,
                matrixView,
                clearButton,
                drawGlyphButton
            ]
        )
        
        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        matrixView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(matrixView.snp.width)
        }
        
        clearButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(20)
            make.left.equalTo(self.snp.centerX).offset(20)
        }
        
        drawGlyphButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(20)
            make.right.equalTo(self.snp.centerX).offset(-20)
        }
    }
}
