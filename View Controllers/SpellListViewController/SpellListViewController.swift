//
//  SpellListViewController.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 18/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

class SpellListViewController: UIViewController {

    private let backgroundImageView = BackgroundImageView()
    private let spellListView = SpellListView()
    private let tableViewManager = SpellListTableViewManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewManager.tableView = spellListView.tableView
        tableViewManager.delegate = self

        view.addSubviews(
            [
                backgroundImageView,
                spellListView
            ]
        )
        
        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        spellListView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(topLayoutGuide.snp.bottom)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        title = "Spell List"
        
        tableViewManager.reload()
    }
}

extension SpellListViewController: SpellListTableViewManagerDelegate {
    func pushRequest(_ vc: SchoolViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
}
