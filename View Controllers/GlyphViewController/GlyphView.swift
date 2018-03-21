//
//  GlyphView.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 15/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import SnapKit

class GlyphView: UIView {
    
    fileprivate let rowsManager = RowsManager()
    
    fileprivate let backgroundImageView = BackgroundImageView()
    fileprivate let backgroundMatrixView = BackgroundMatrixView()
    fileprivate let frontMatrixView = FrontMatrixView()
    fileprivate let clearButton = UIButton()
    fileprivate let drawGlyphButton = UIButton()
    
    fileprivate var glyph: Glyph!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(_ glyph: Glyph) {
        super.init(frame: CGRect())
        
        self.glyph = glyph

        backgroundColor = .clear
                
        clearButton.setTitle("Clear", for: .normal)
        clearButton.setTitleColor(.black, for: .normal)
        clearButton.addTarget(self, action: #selector(clearButtonTapped), for: .touchUpInside)
        clearButton.layer.borderColor = UIColor.black.cgColor
        clearButton.layer.borderWidth = 2
        
        drawGlyphButton.setTitle("Draw", for: .normal)
        drawGlyphButton.setTitleColor(.black, for: .normal)
        drawGlyphButton.addTarget(self, action: #selector(drawGlyphButtonTapped), for: .touchUpInside)
        drawGlyphButton.layer.borderColor = UIColor.black.cgColor
        drawGlyphButton.layer.borderWidth = 2
        
        addSubviewsAndSetupConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        rowsManager.createRowsForFrame(backgroundMatrixView.frame)
        
        backgroundMatrixView.rowsManager = rowsManager
        frontMatrixView.rowsManager = rowsManager
        
        frontMatrixView.setup(with: glyph)
    }
    
    func clearButtonTapped() {
        frontMatrixView.clear()
    }

    func drawGlyphButtonTapped() {
        frontMatrixView.drawGlyph()
    }
}

fileprivate extension GlyphView {
    
    func addSubviewsAndSetupConstraints() {
        addSubviews(
            [
                backgroundImageView,
                backgroundMatrixView,
                frontMatrixView,
                clearButton,
                drawGlyphButton
            ]
        )
        
        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        backgroundMatrixView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(backgroundMatrixView.snp.width)
        }
        
        frontMatrixView.snp.makeConstraints { (make) in
            make.edges.equalTo(backgroundMatrixView)
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
