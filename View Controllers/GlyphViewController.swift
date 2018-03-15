//
//  GlyphViewController.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 14/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

class GlyphViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        
        view = BackgroundMatrixView()
    }

}
