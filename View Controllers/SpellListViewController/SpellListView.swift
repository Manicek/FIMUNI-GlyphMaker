//
//  SpellListView.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 18/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

class SpellListView: UIView {
    
    let tableView = UITableView()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        super.init(frame: CGRect())
        
        backgroundColor = .white
        
        tableView.backgroundColor = .clear
        
        addSubviewsAndSetupConstraints()
    }

}

fileprivate extension SpellListView {
    
    func addSubviewsAndSetupConstraints() {
        addSubviews(
            [
                tableView
            ]
        )
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}
