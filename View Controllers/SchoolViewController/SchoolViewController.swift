//
//  SchoolViewController.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 14/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

class SchoolViewController: UIViewController {

    private var schoolView: SchoolView {
        return view as! SchoolView
    }
    
    private var glyph = Glyph.testGlyph
    
    init(glyph: Glyph?) {
        super.init(nibName: nil, bundle: nil)
        
        if let glyph = glyph {
            self.glyph = glyph
        } else {
            self.glyph = Glyph.testGlyph
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        view = SchoolView(glyph)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        schoolView.glyphView.delegate = self
        print(glyph)
    }
}

extension SchoolViewController: GlyphViewDelegate {
    func finishedGlyphWithResults(okPointsRatio: Double) {
        schoolView.glyphView.clear()
        showBasicAlert(message: String(format: "%.0f %% accuracy", 100 * okPointsRatio), title: "Result")
    }
}
