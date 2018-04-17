//
//  StartViewController.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 18/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    private var startView: StartView {
        return view as! StartView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        startView.spellsButton.addTarget(self, action: #selector(spellsButtonTapped), for: .touchUpInside)
        startView.fightButton.addTarget(self, action: #selector(fightButtonTapped), for: .touchUpInside)
        startView.creaturesButton.addTarget(self, action: #selector(creaturesButtonTapped), for: .touchUpInside)
        startView.createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)

    }
    
    override func loadView() {
        super.loadView()
        
        view = StartView()
    }

    @objc func spellsButtonTapped() {
        navigationController?.pushViewController(SpellListViewController(), animated: true)
    }
    
    @objc func fightButtonTapped() {
        navigationController?.present(BattleViewController(), animated: true)
    }
    
    @objc func creaturesButtonTapped() {
        //navigationController?.pushViewController(<#T##viewController: UIViewController##UIViewController#>, animated: true)
    }
    
    @objc func createButtonTapped() {
        navigationController?.pushViewController(GlyphCreationViewController(), animated: true)
    }
}
