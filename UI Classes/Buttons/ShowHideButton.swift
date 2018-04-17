//
//  ShowHideButton.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 13/04/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

enum ShowHideStatus {
    case show
    case hide
    
    var string: String {
        switch self {
        case .show: return "Show"
        case .hide: return "Hide"
        }
    }
}

class ShowHideButton: RegularButton {
    
    private(set) var status = ShowHideStatus.show
    private var whatString = ""

    init(status: ShowHideStatus, what: String) {
        super.init(status.string + " " + what)
        
        self.status = status
        self.whatString = what
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setStatus(_ status: ShowHideStatus) {
        setTitle(status.string + " " + whatString, for: .normal)
        self.status = status
    }
}
