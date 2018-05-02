//
//  SpellListTableViewManager.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 18/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

protocol SpellListTableViewManagerDelegate: class {
    func pushRequest(_ vc: SchoolViewController)
}

class SpellListTableViewManager: NSObject {
    
    struct Const {
        static let cellHeight: CGFloat = 45
        static let headerHeight: CGFloat = 20
        static let fireSectionIndex = 0
        static let coldSectionIndex = 1
    }
    
    weak var delegate: SpellListTableViewManagerDelegate?
    
    weak var tableView: UITableView? {
        didSet {
            tableView?.delegate = self
            tableView?.dataSource = self
            tableView?.register(SpellListTableViewCell.self, forCellReuseIdentifier: SpellListTableViewCell.cellIdentifier)
            tableView?.separatorStyle = .none
        }
    }
    
    private var fireSpells = [Spell]()
    private var coldSpells = [Spell]()
    
    func reload() {
        fireSpells = SpellStore.getSpells(ofType: .fire)
        coldSpells = SpellStore.getSpells(ofType: .cold)
        
        print("Fire: \(fireSpells.count)")
        print("Cold: \(coldSpells.count)")
        
        tableView?.reloadData()
    }
}

extension SpellListTableViewManager: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case Const.fireSectionIndex: delegate?.pushRequest(SchoolViewController(glyph: fireSpells[indexPath.row].glyph))
        case Const.coldSectionIndex: delegate?.pushRequest(SchoolViewController(glyph: coldSpells[indexPath.row].glyph))
        default: return
        }
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
}

extension SpellListTableViewManager: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SpellListTableViewCell.cellIdentifier, for: indexPath) as! SpellListTableViewCell
        switch indexPath.section {
        case Const.fireSectionIndex: cell.configure(with: fireSpells[indexPath.row])
        case Const.coldSectionIndex: cell.configure(with: coldSpells[indexPath.row])
        default: break
        }
        return cell
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
