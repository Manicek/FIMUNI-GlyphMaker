//
//  Defaults.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 06/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import Foundation

fileprivate struct DefaultsKey {
    
    static let appHasBeenLaunchedBefore = "appHasBeenLaunchedBefore"
}

final class Defaults {
    
    static func setupForFirstLaunch() {
        appHasBeenLaunchedBefore = true
    }
    
    static var appHasBeenLaunchedBefore: Bool {
        get {
            return UserDefaults.standard.bool(forKey: DefaultsKey.appHasBeenLaunchedBefore)
        }
        set(value) {
            UserDefaults.standard.set(value, forKey: DefaultsKey.appHasBeenLaunchedBefore)
        }
    }
}
