//
//  SpellListTableViewManager.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 18/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

class SpellListTableViewManager: NSObject {
    
    struct Const {
        static let cellHeight: CGFloat = 45
        static let headerHeight: CGFloat = 20
        static let fireSectionIndex = 0
        static let coldSectionIndex = 1
    }
    
    weak var tableView: UITableView? {
        didSet {
            tableView?.delegate = self
            tableView?.dataSource = self
            tableView?.register(SpellListTableViewCell.self, forCellReuseIdentifier: SpellListTableViewCell.cellIdentifier)
            tableView?.separatorStyle = .none
        }
    }
    
    fileprivate var fireSpells = [Spell]()
    fileprivate var coldSpells = [Spell]()
    
    func reload() {
        if let fireResults = SpellStore.getSpells(ofType: .fire) {
            fireSpells = Array(fireResults)
        } else {
            fireSpells = [Spell]()
        }
        
        if let coldResults = SpellStore.getSpells(ofType: .cold) {
            coldSpells = Array(coldResults)
        } else {
            coldSpells = [Spell]()
        }
        
        tableView?.reloadData()
    }
}

extension SpellListTableViewManager: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Const.cellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Const.headerHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case Const.fireSectionIndex: return SpellListHeaderView(forType: .fire)
        case Const.coldSectionIndex: return SpellListHeaderView(forType: .cold)
        default: return nil
        
    }
}

extension SpellListTableViewManager: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case Const.fireSectionIndex: return fireSpells.count
        case Const.coldSectionIndex: return coldSpells.count
        default: return 0
        }
    }
}
