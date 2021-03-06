//
//  AppDelegate.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 14/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        GlyphMakerConstants.randomizer = AppConstants.randomizer
        GlyphMakerConstants.numberOfColumns = 5
        GlyphMakerConstants.numberOfRows = 5
        GlyphMakerConstants.lineWidth = 3
        GlyphMakerConstants.allowedOffsetMultiplier = 0.3
        
        if !Defaults.appHasBeenLaunchedBefore {
            performFirstLaunchSetup()
        }
        
        setupWindow()
        
        return true
    }
}

private extension AppDelegate {
    
    func performFirstLaunchSetup() {
        Defaults.setupForFirstLaunch()
        createBasicSpells()
    }
    
    func setupWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().barTintColor = .clear
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedStringKey.foregroundColor : UIColor.white,
        ]
        
        let navigationController = UINavigationController(rootViewController: StartViewController())
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func createBasicSpells() {
        var fireballGlyph = Glyph.testGlyph
        if let glyph = Glyph.generateDeterministicRandomGlyph(coordinatesCount: 5, variant: 0, preventOverlaps: true) {
            fireballGlyph = glyph
        }
        let fireball = Spell(name: "Fireball", damageType: .fire, damage: 50, glyph: fireballGlyph, imageIndex: 0)
        fireball.unlocked = true
        
        var frostSpearGlyph = Glyph.testGlyph
        if let glyph = Glyph.generateDeterministicRandomGlyph(coordinatesCount: 5, variant: 1, preventOverlaps: true) {
            frostSpearGlyph = glyph
        }
        let frostSpear = Spell(name: "Frost Grasp", damageType: .cold, damage: 40, glyph: frostSpearGlyph, imageIndex: 1)
        frostSpear.unlocked = true
        
        var infernoGlyph = Glyph.testGlyph
        if let glyph = Glyph.generateDeterministicRandomGlyph(coordinatesCount: 10, variant: 0, preventOverlaps: true) {
            infernoGlyph = glyph
        }
        let inferno = Spell(name: "Inferno", damageType: .fire, damage: 110, glyph: infernoGlyph, imageIndex: 2)
        
        var boulderGlyph = Glyph.testGlyph
        if let glyph = Glyph.generateDeterministicRandomGlyph(coordinatesCount: 6, variant: 0, preventOverlaps: true) {
            boulderGlyph = glyph
        }
        let boulderThrow = Spell(name: "Boulder Throw", damageType: .physical, damage: 65, glyph: boulderGlyph, imageIndex: 3)
        boulderThrow.unlocked = true
        
        SpellStore.add(spell: fireball)
        SpellStore.add(spell: frostSpear)
        SpellStore.add(spell: inferno)
        SpellStore.add(spell: boulderThrow)
    }
}
