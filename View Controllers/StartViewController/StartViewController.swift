//
//  StartViewController.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 18/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    fileprivate var startView: StartView {
        return view as! StartView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        startView.schoolButton.addTarget(self, action: #selector(schoolButtonTapped), for: .touchUpInside)
        startView.fightButton.addTarget(self, action: #selector(fightButtonTapped), for: .touchUpInside)

    }
    
    override func loadView() {
        super.loadView()
        
        view = StartView()
    }

    func schoolButtonTapped() {
        navigationController?.pushViewController(SpellListViewController(), animated: true)
    }
    
    func fightButtonTapped() {
        navigationController?.present(BattleViewController(), animated: true, completion: nil)
    }
}
