//
//  CreationView.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 12/04/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

class CreationView: UIView {
    
    fileprivate let rowsView = RowsView()
    fileprivate let resetButton = RegularButton("Reset")
    fileprivate let doneButton = RegularButton("Done")
    fileprivate let breakpointButton = RegularButton("Breakpoint")
    
    fileprivate var breakpoints = [Int]()
    fileprivate var coordinates = [AreaCoordinate]()
    
    init() {
        super.init(frame: CGRect())
        
        backgroundColor = .white
        
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

    func resetButtonTapped() {
        breakpoints = [Int]()
        coordinates = [AreaCoordinate]()
    }
    
    func breakpointButtonTapped() {
        breakpoints.append(coordinates.count)
    }
}

fileprivate extension CreationView {
    
    func addSubviewsAndSetupConstraints() {
        addSubviews(
            [
                rowsView,
                doneButton,
                resetButton,
                breakpointButton
            ]
        )
        
        rowsView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(rowsView.snp.width)
        }
    }
}
