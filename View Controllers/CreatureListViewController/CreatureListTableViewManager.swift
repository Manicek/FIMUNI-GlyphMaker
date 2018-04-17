//
//  CreatureListTableViewManager.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 17/04/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

class CreatureListTableViewManager: NSObject {
    
    private var creatures = [Creature]()
}

extension CreatureListTableViewManager: UITableViewDelegate {
    
}

extension CreatureListTableViewManager: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return creatures.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CreatureListTableViewCell.cellIdentifier, for: indexPath) as! CreatureListTableViewCell

        return cell
    }
}
