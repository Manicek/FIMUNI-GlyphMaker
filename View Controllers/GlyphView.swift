//
//  GlyphView.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 14/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import SnapKit

class GlyphView: UIView {
    
    struct Const {
        static let matrixSize = 5
    }
    
    fileprivate let path = UIBezierPath()
    fileprivate var points = [CGPoint]()
    
    init() {
        super.init(frame: CGRect())
        log.debug()
        
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        log.debug()
        UIColor.red.setStroke()
        path.stroke()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        log.debug()
        if let touch = touches.first {
            let firstPoint = touch.location(in: self)
            points.append(firstPoint)
            path.move(to: firstPoint)
        }
    }
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        log.debug()
        
        path.addLine(to: toPoint)
        
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let currentPoint = touch.location(in: self)

            drawLineFrom(fromPoint: points.last!, toPoint: currentPoint)
            points.append(currentPoint)
            log.debug("Pocet bodu: \(points.count)")
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        log.debug()
        points = [CGPoint]()
    }
}

fileprivate extension GlyphView {
    func addSubviewsAndSetupConstraints() {
        addSubviews(
            [

            ]
        )
        
    }
}
