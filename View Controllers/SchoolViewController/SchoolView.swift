//
//  SchoolView.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 15/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import SnapKit

class SchoolView: UIView {
    
    private let backgroundImageView = BackgroundImageView()
    private let glyphView = GlyphView()
    private let clearButton = RegularButton("Clear")
    private let drawGlyphButton = RegularButton("Draw")
    private let showHideTestPathsButton = ShowHideButton(status: .hide, what: "paths")
    private let showHideMatrixButton = ShowHideButton(status: .hide, what: "matrix")
    
    private var glyph: Glyph!

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

        glyphView.createRows()
        glyphView.setup(with: glyph)
    }
    
    @objc func clearButtonTapped() {
        glyphView.clear()
    }

    @objc func drawGlyphButtonTapped() {
        glyphView.drawGlyph()
    }
    
    @objc func showHideTestPathsButtonTapped() {
        switch showHideTestPathsButton.status {
        case .hide:
            showHideTestPathsButton.setStatus(.show)
            glyphView.hideTestPaths()
        case .show:
            showHideTestPathsButton.setStatus(.hide)
            glyphView.showTestPaths()
        }
    }
    
    @objc func showHideMatrixButtonTapped() {
        switch showHideMatrixButton.status {
        case .hide:
            showHideMatrixButton.setStatus(.show)
            glyphView.hideMatrix()
        case .show:
            showHideMatrixButton.setStatus(.hide)
            glyphView.showMatrix()
        }
    }
}

private extension SchoolView {
    
    func addSubviewsAndSetupConstraints() {
        addSubviews(
            [
                backgroundImageView,
                glyphView,
                clearButton,
                drawGlyphButton,
                showHideTestPathsButton,
                showHideMatrixButton
            ]
        )
        
        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        glyphView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(glyphView.snp.width)
        }
        
        clearButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(20)
            make.left.equalTo(self.snp.centerX).offset(20)
        }
        
        drawGlyphButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(20)
            make.right.equalTo(self.snp.centerX).offset(-20)
        }
        
        showHideTestPathsButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(drawGlyphButton.snp.top).offset(-10)
            make.right.equalTo(drawGlyphButton)
        }
        
        showHideMatrixButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(clearButton.snp.top).offset(-10)
            make.left.equalTo(clearButton)
        }
    }
}
