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
    fileprivate let clearButton = UIButton()
    fileprivate let drawGlyphButton = UIButton()
    
    fileprivate var glyph: Glyph!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        super.init(frame: CGRect())
        
        backgroundColor = .white
        
        backgroundMatrixView.delegate = self
        
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
        
        glyph = Glyph(name: "Test", difficulty: .easy, areasIndexes:
            [AreaIndexTuple(2, 1), AreaIndexTuple(0, 2), AreaIndexTuple(2, 3), AreaIndexTuple(3, 1), AreaIndexTuple(3, 3)],
                      breakpointsIndexes: [3])
        
        addSubviewsAndSetupConstraints()
    }
    
    func clearButtonTapped() {
        log.debug()
        clear()
    }

    func drawGlyphButtonTapped() {
        log.debug()
        drawGlyph(glyph)
    }
}

extension GlyphView: BackgroundMatrixViewDelegate {
    func sendRows(_ rows: [[CGRect]]) {
        frontMatrixView.rows = rows
    }
}

fileprivate extension GlyphView {
    
    func drawGlyph(_ glyph: Glyph) {
        frontMatrixView.drawGlyph(glyph)
    }
    
    func clear() {
        frontMatrixView.clear()
    }
    
    func addSubviewsAndSetupConstraints() {
        addSubviews(
            [
                backgroundMatrixView,
                frontMatrixView,
                clearButton,
                drawGlyphButton
            ]
        )
        
        backgroundMatrixView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(backgroundMatrixView.snp.width)
        }
        
        frontMatrixView.snp.makeConstraints { (make) in
            make.edges.equalTo(backgroundMatrixView)
        }
        
        clearButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(15)
            make.centerX.equalToSuperview()
        }
        
        drawGlyphButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(15)
            make.centerX.equalToSuperview()
        }
    }
}
