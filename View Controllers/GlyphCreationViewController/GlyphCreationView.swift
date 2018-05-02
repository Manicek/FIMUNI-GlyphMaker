//
//  GlyphCreationView.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 12/04/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

class GlyphCreationView: UIView {
    
    private let backgroundImageView = BackgroundImageView()
    let rowsView = RowsView()
    
    let resetButton = RegularButton("Reset")
    let doneButton = RegularButton("Done")
    let breakpointButton = RegularButton("Breakpoint")
    
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
    
    func createAndDrawPath(coordinates: [RealmAreaCoordinate], breakpoints: [Int]) {
        rowsView.path = UIBezierPath.newPath()
        
        if !coordinates.isEmpty {
            rowsView.path.move(to: rowsView.rows[coordinates.first!.x][coordinates.first!.y].center)
            
            for i in 1..<coordinates.count {
                if breakpoints.contains(i) {
                    rowsView.path.move(to: rowsView.rows[coordinates[i].x][coordinates[i].y].center)
                } else {
                    rowsView.path.addLine(to: rowsView.rows[coordinates[i].x][coordinates[i].y].center)
                }
            }
        }
        
        rowsView.setNeedsDisplay()
    }
}

private extension GlyphCreationView {
    
    func addSubviewsAndSetupConstraints() {
        addSubviews(
            [
                backgroundImageView,
                rowsView,
                resetButton,
                breakpointButton,
                doneButton
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
    }
}
