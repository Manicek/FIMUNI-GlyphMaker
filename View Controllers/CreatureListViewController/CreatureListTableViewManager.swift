//
//  CreatureListTableViewManager.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 17/04/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

protocol CreatureListTableViewManagerDelegate: class {
    func pushRequest(_ vc: CreatureViewController)
}

class CreatureListTableViewManager: NSObject {
    
    struct Const {
        static let cellHeight: CGFloat = 45
    }
    
    weak var delegate: CreatureListTableViewManagerDelegate?
    
    weak var tableView: UITableView? {
        didSet {
            tableView?.delegate = self
            tableView?.dataSource = self
            tableView?.register(CreatureListTableViewCell.self, forCellReuseIdentifier: CreatureListTableViewCell.cellIdentifier)
            tableView?.separatorStyle = .none
        }
    }
    
    private var creatures = [Creature]()
    
    func reload() {
        if let creaturesResults = CreatureStore.getAllCreatures() {
            creatures = Array(creaturesResults)
        } else {
            creatures = [Creature]()
        }
        
        print("Creatures: \(creatures.count)")

        tableView?.reloadData()
    }
}

extension CreatureListTableViewManager: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.pushRequest(CreatureViewController(creature: creatures[indexPath.row]))
    }
}

extension CreatureListTableViewManager: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return creatures.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CreatureListTableViewCell.cellIdentifier, for: indexPath) as! CreatureListTableViewCell
        cell.configure(with: creatures[indexPath.row])
        return cell
    }
}
