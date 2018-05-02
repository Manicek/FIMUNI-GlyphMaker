//
//  GlyphCreationViewController.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 12/04/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

class GlyphCreationViewController: UIViewController {

    private var glyphCreationView: GlyphCreationView {
        return view as! GlyphCreationView
    }
    
    private var breakpoints = [Int]()
    private var coordinates = [RealmAreaCoordinate]()
    
    private var areaTapGestureRecognizer = UITapGestureRecognizer()
    
    private var onlyOneAreaAddedAfterBreakpoint = false
    private var lastArea = MatrixArea(frame: CGRect.zero, coordinate: RealmAreaCoordinate.nonExistent)
    private var blockedLines = [Line]()
    
    override func loadView() {
        super.loadView()
        
        view = GlyphCreationView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        glyphCreationView.resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        glyphCreationView.doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        glyphCreationView.breakpointButton.addTarget(self, action: #selector(breakpointButtonTapped), for: .touchUpInside)
        
        areaTapGestureRecognizer.addTarget(self, action: #selector(areaTapped))
        glyphCreationView.rowsView.addGestureRecognizer(areaTapGestureRecognizer)
    }
    
    @objc func areaTapped() {
        for area in glyphCreationView.rowsView.matrixAreas {
            if (area.frame.contains(areaTapGestureRecognizer.location(in: glyphCreationView.rowsView))) {
                if area == lastArea {
                    return
                }
                
                if lastArea.coordinate == RealmAreaCoordinate.nonExistent {
                    lastArea = area
                    area.updateHighlighted(true)
                    coordinates.append(area.coordinate)
                    return
                }
                
                if breakpoints.contains(coordinates.count) {
                    lastArea.updateHighlighted(false)
                    area.updateHighlighted(true)
                    lastArea = area
                    coordinates.append(area.coordinate)
                    return
                }
                
                let candidateLine = Line(from: lastArea.coordinate, to: area.coordinate)
                if candidateLine.overlapsAnyLineIn(blockedLines) {
                    log.warning("Line \(candidateLine) is blocked")
                    showBasicAlert(message: "Line would overlap an existing line", title: "No")
                    return
                }
                lastArea.updateHighlighted(false)
                area.updateHighlighted(true)
                lastArea = area
                blockedLines.append(candidateLine)
                coordinates.append(area.coordinate)
                glyphCreationView.createAndDrawPath(coordinates: coordinates, breakpoints: breakpoints)
                return
            }
        }
    }
    
    @objc func resetButtonTapped() {
        breakpoints = [Int]()
        coordinates = [RealmAreaCoordinate]()
        lastArea.updateHighlighted(false)
        lastArea = MatrixArea(frame: CGRect.zero, coordinate: RealmAreaCoordinate(-1, -1))
        blockedLines = [Line]()
        glyphCreationView.createAndDrawPath(coordinates: coordinates, breakpoints: breakpoints)
    }
    
    @objc func doneButtonTapped() {
        let glyph = RealmGlyph(areasCoordinates: coordinates, breakpointsIndexes: breakpoints)
        log.debug(glyph)
    }
    
    @objc func breakpointButtonTapped() {
        let newBreakpoint = coordinates.count
        if !breakpoints.contains(newBreakpoint) && !breakpoints.contains(newBreakpoint - 1) {
            breakpoints.append(coordinates.count)
        }
    }
}
