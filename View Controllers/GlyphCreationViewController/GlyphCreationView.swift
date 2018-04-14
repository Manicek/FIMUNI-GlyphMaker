//
//  GlyphCreationView.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 12/04/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

class GlyphCreationView: UIView {
    
    fileprivate let backgroundImageView = BackgroundImageView()
    let rowsView = RowsView()
    
    let resetButton = RegularButton("Reset")
    let doneButton = RegularButton("Done")
    let breakpointButton = RegularButton("Breakpoint")
    let undoButton = RegularButton("Undo")
    let redoButton = RegularButton("Redo")
    
    init() {
        super.init(frame: CGRect())
        
        backgroundColor = .clear
        
        rowsView.showMatrix()
        
        addSubviewsAndSetupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        rowsView.createRows()
    }
}

fileprivate extension GlyphCreationView {
    
    func addSubviewsAndSetupConstraints() {
        addSubviews(
            [
                backgroundImageView,
                rowsView,
                resetButton,
                breakpointButton,
                doneButton,
                undoButton,
                redoButton
            ]
        )
        
        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        rowsView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(rowsView.snp.width)
        }
        
        resetButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(20)
            make.left.equalToSuperview().inset(20)
        }
        
        breakpointButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }
        
        doneButton.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(20)
            make.right.equalToSuperview().inset(20)
        }
        
        undoButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(rowsView.snp.top).offset(-20)
            make.right.equalTo(self.snp.centerX).offset(-20)
        }
        
        redoButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(rowsView.snp.top).offset(-20)
            make.left.equalTo(self.snp.centerX).offset(20)
        }
    }
}
