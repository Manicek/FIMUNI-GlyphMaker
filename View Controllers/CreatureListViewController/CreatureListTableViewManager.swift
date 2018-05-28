//
//  CreatureListTableViewManager.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 17/04/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

protocol CreatureListTableViewManagerDelegate: class {
    func pushRequest(_ vc: CreatureTypeViewController)
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
}

extension CreatureListTableViewManager: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.pushRequest(CreatureTypeViewController(creatureType: CreatureType.allValues[indexPath.row]))
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
}

extension CreatureListTableViewManager: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return CreatureType.allValues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CreatureListTableViewCell.cellIdentifier, for: indexPath) as! CreatureListTableViewCell
        cell.configure(with: CreatureType.allValues[indexPath.section])
        return cell
    }
}
