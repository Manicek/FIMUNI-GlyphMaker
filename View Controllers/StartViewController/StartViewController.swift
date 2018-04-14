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

        startView.spellsButton.addTarget(self, action: #selector(spellsButtonTapped), for: .touchUpInside)
        startView.fightButton.addTarget(self, action: #selector(fightButtonTapped), for: .touchUpInside)
        startView.creaturesButton.addTarget(self, action: #selector(creaturesButtonTapped), for: .touchUpInside)
        startView.createButton.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)

    }
    
    override func loadView() {
        super.loadView()
        
        view = StartView()
    }

    func spellsButtonTapped() {
        navigationController?.pushViewController(SpellListViewController(), animated: true)
    }
    
    func fightButtonTapped() {
        navigationController?.present(BattleViewController(), animated: true)
    }
    
    func creaturesButtonTapped() {
        //navigationController?.pushViewController(<#T##viewController: UIViewController##UIViewController#>, animated: true)
    }
    
    func createButtonTapped() {
        navigationController?.pushViewController(GlyphCreationViewController(), animated: true)
    }
}
