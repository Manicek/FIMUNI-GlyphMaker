//
//  GlyphViewController.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 14/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

class GlyphViewController: UIViewController {

    fileprivate var glyphView: GlyphView {
        return view as! GlyphView
    }
    
    fileprivate var glyph = Glyph.testGlyph
    
    func setup(with glyph: Glyph?) {
        if let glyph = glyph {
            self.glyph = glyph
        } else {
            self.glyph = Glyph.testGlyph
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        
        view = GlyphView(glyph)
    }
}
