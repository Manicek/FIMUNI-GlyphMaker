//
//  FrontMatrixView.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 15/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

class FrontMatrixView: UIView {
    
    fileprivate var path = UIBezierPath()
    fileprivate var lastPoint = CGPoint.zero
    
    var rows = [[CGRect]]()
    
    init() {
        super.init(frame: CGRect())
        log.debug()
        
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func drawGlyph(_ glyph: Glyph) {
        log.debug()
//        let areasIndexes = glyph.parseAreasToIndexes()
        let areasIndexes = glyph.areasIndexes
        if areasIndexes.count == 0 {
            return
        }
        
        var iterator = areasIndexes.makeIterator()
        
        let currentIndex = iterator.next()!
        
        path = UIBezierPath()
        
        path.move(to: rows[currentIndex.x][currentIndex.y].center)
        
        for i in 1..<areasIndexes.count {
            let nextTuple = iterator.next()!
            
            let nextPoint = rows[nextTuple.x][nextTuple.y].center
            
            if glyph.breakpointsIndexes.contains(i) {
                path.move(to: nextPoint)
            } else {
                path.addLine(to: nextPoint)
            }
        }
        
        setNeedsDisplay()
    }
    
    func clear() {
        path = UIBezierPath()
        setNeedsDisplay()
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
            lastPoint = firstPoint
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
            
            drawLineFrom(fromPoint: lastPoint, toPoint: currentPoint)
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        log.debug()
    }
}
