//
//  GlyphCreationViewController.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 12/04/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

class GlyphCreationViewController: UIViewController {

    fileprivate var glyphCreationView: GlyphCreationView {
        return view as! GlyphCreationView
    }
    
    fileprivate var breakpoints = [Int]()
    fileprivate var coordinates = [AreaCoordinate]()
    
    fileprivate var areaTapGestureRecognizer = UITapGestureRecognizer()
    
    fileprivate var lastActionWasAddingBreakpoint = false
    fileprivate var lastArea = MatrixArea(frame: CGRect.zero, coordinate: AreaCoordinate(-1, -1))
    fileprivate var blockedLines = [Line]()
    
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
    
    func areaTapped() {
        for area in glyphCreationView.rowsView.matrixAreas {
            if (area.frame.contains(areaTapGestureRecognizer.location(in: glyphCreationView.rowsView))) {
                if area != lastArea {
                    let candidateLine = Line(from: lastArea.coordinate, to: area.coordinate)
                    if blockedLines.contains(candidateLine) {
                        log.warning("Line \(candidateLine) is blocked")
                        showBasicAlert(message: "Invalid line", title: "No")
                        return
                    }
                    lastArea.updateHighlighted(false)
                    lastArea = area
                    lastArea.updateHighlighted(true)
                    blockedLines.append(candidateLine)
                    coordinates.append(area.coordinate)
                    lastActionWasAddingBreakpoint = false
                    glyphCreationView.createAndDrawPath(coordinates: coordinates, breakpoints: breakpoints)
                    break
                }
            }
        }
    }
    
    func resetButtonTapped() {
        breakpoints = [Int]()
        coordinates = [AreaCoordinate]()
        lastActionWasAddingBreakpoint = false
        lastArea.updateHighlighted(false)
        lastArea = MatrixArea(frame: CGRect.zero, coordinate: AreaCoordinate(-1, -1))
        blockedLines = [Line]()
        glyphCreationView.createAndDrawPath(coordinates: coordinates, breakpoints: breakpoints)
    }
    
    func doneButtonTapped() {
        let glyph = Glyph(areasCoordinates: coordinates, breakpointsIndexes: breakpoints)
        log.debug(glyph)
    }
    
    func breakpointButtonTapped() {
        if lastActionWasAddingBreakpoint {
            return
        }
        breakpoints.append(coordinates.count)
        lastActionWasAddingBreakpoint = true
    }
}
