//
//  GlyphView.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 15/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import SnapKit

class GlyphView: UIView {
    
    fileprivate let backgroundImageView = BackgroundImageView()
    fileprivate let matrixView = MatrixView()
    fileprivate let clearButton = UIButton()
    fileprivate let drawGlyphButton = UIButton()
    
    fileprivate var glyph: Glyph!

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

        matrixView.createRows()
        matrixView.setup(with: glyph)
    }
    
    func clearButtonTapped() {
        matrixView.clear()
    }

    func drawGlyphButtonTapped() {
        matrixView.drawGlyph()
    }
}

fileprivate extension GlyphView {
    
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
