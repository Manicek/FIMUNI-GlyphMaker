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

    static let lineWidth: CGFloat = 6
    static let allowedOffsetMultiplier: CGFloat = 0.2
    static let matrixSize = 5
    static let minimumPercentageToPass: Double = 0.65 // Value between 0 and 1
    static var randomizer: Int {
        if let alreadyLoadedValue = loadedRandomizer {
            return alreadyLoadedValue
        }
        if let value: Int = Keychain.value(forKey: "randomizer") {
            log.debug("Loading randomizer with value \(value) from Keychain")
            loadedRandomizer = value
            return value
        } else {
            let value = abs(UIDevice.current.identifierForVendor!.uuidString.hashValue)
            Keychain.set(value, forKey: "randomizer")
            log.debug("Generating randomizer with value \(value) and saving it to Keychain")
            return value
        }
    }
    
    fileprivate static var loadedRandomizer: Int?
}
