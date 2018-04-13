//
//  CreationViewController.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 12/04/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

class CreationViewController: UIViewController {

    fileprivate var creationView: CreationView {
        return view as! CreationView
    }
    
    override func loadView() {
        super.loadView()
        
        view = CreationView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
