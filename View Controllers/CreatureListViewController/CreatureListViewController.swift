//
//  CreatureListViewController.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 17/04/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

class CreatureListViewController: UIViewController {

    private let backgroundImageView = BackgroundImageView()
    private let creatureListView = CreatureListView()
    private let tableViewManager = CreatureListTableViewManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewManager.tableView = creatureListView.tableView
        tableViewManager.delegate = self
        
        view.addSubviews(
            [
                backgroundImageView,
                creatureListView
            ]
        )
        
        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        creatureListView.snp.makeConstraints { (make) in
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

extension CreatureListViewController: CreatureListTableViewManagerDelegate {
    func pushRequest(_ vc: CreatureViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
}