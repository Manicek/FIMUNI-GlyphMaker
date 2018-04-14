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
    
    override func loadView() {
        super.loadView()
        
        view = GlyphCreationView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        glyphCreationView.resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        glyphCreationView.doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        glyphCreationView.breakpointButton.addTarget(self, action: #selector(breakpointButtonTapped), for: .touchUpInside)
        glyphCreationView.undoButton.addTarget(self, action: #selector(undoButtonTapped), for: .touchUpInside)
        glyphCreationView.redoButton.addTarget(self, action: #selector(redoButtonTapped), for: .touchUpInside)
        
        areaTapGestureRecognizer.addTarget(self, action: #selector(areaTapped))
        glyphCreationView.rowsView.addGestureRecognizer(areaTapGestureRecognizer)
    }
    
    func areaTapped() {
        for area in glyphCreationView.rowsView.matrixAreas {
            if (area.frame.contains(areaTapGestureRecognizer.location(in: glyphCreationView.rowsView))) {
                coordinates.append(area.coordinate)
                break
            }
        }
    }
    
    func resetButtonTapped() {
        breakpoints = [Int]()
        coordinates = [AreaCoordinate]()
    }
    
    func doneButtonTapped() {
        let glyph = Glyph(areasCoordinates: coordinates, breakpointsIndexes: breakpoints)
        log.debug(glyph)
    }
    
    func breakpointButtonTapped() {
        breakpoints.append(coordinates.count)
    }
    
    func undoButtonTapped() {
        
    }
    
    func redoButtonTapped() {
        
    }
}
