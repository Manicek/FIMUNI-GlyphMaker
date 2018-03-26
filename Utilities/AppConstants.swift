//
//  AppConstants.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 16/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit
import Simple_KeychainSwift

class AppConstants: NSObject {

    static let lineWidth: CGFloat = 3
    static let allowedOffsetMultiplier: CGFloat = 0.15
    static let matrixSize = 5
    static let minimumPercentageToPass: Double = 80
    static var randomizer: Int {
        if let alreadyLoadedValue = loadedRandomizer {
            return alreadyLoadedValue
        }
        if let value: Int = Keychain.value(forKey: "randomizer") {
            loadedRandomizer = value
            return value
        } else {
            let value = UIDevice.current.identifierForVendor!.uuidString.hashValue
            Keychain.set(value, forKey: "randomizer")
            return value
        }
    }
    
    fileprivate static var loadedRandomizer: Int?
}
