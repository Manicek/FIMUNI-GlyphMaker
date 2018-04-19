//
//  CreatureListView.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 17/04/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

class CreatureListView: UIView {

    struct Const {
        static let tableViewWidthMultiplier: CGFloat = 0.95
    }
    
    let tableView = UITableView()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: CGRect())
        
        backgroundColor = .clear
        
        tableView.backgroundColor = .clear
        
        addSubviewsAndSetupConstraints()
    }
}

private extension CreatureListView {
    
    func addSubviewsAndSetupConstraints() {
        addSubviews(
            [
                tableView
            ]
        )
        
        tableView.snp.makeConstraints { (make) in
            make.center.height.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(Const.tableViewWidthMultiplier)
        }
    }
}
