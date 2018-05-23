//
//  CreatureViewController.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 19/04/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

class CreatureTypeViewController: UIViewController {
    
    private var creatureView: CreatureTypeView {
        return view as! CreatureTypeView
    }
    
    private var creatureType = CreatureType.allValues[0]
    
    override func loadView() {
        super.loadView()
        
        view = CreatureTypeView(creatureType)
    }
    
    init(creatureType: CreatureType) {
        super.init(nibName: nil, bundle: nil)
        
        self.creatureType = creatureType
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
