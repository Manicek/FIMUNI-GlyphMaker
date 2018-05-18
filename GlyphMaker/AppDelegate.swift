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
        GlyphMakerConstants.numberOfColumns = 20
        GlyphMakerConstants.numberOfRows = 20
        GlyphMakerConstants.lineWidth = 3
        
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
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().barTintColor = .clear
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedStringKey.foregroundColor : UIColor.white,
        ]
        
        let navigationController = UINavigationController(rootViewController: StartViewController())
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func createBasicSpells() {
        let fireball = Spell(name: "Fireball", damageType: .fire, damage: 50, glyph: Glyph.generateDeterministicRandomGlyph(coordinatesCount: 5, variant: 0, preventOverlaps: true), imageIndex: 0)
        fireball.unlocked = true
        
        let frostSpear = Spell(name: "Frost Grasp", damageType: .cold, damage: 40, glyph: Glyph.generateDeterministicRandomGlyph(coordinatesCount: 5, variant: 1, preventOverlaps: true), imageIndex: 1)
        frostSpear.unlocked = true
        
        let inferno = Spell(name: "Inferno", damageType: .fire, damage: 110, glyph: Glyph.generateDeterministicRandomGlyph(coordinatesCount: 10, variant: 0, preventOverlaps: true), imageIndex: 2)
        
        SpellStore.add(spell: fireball)
        SpellStore.add(spell: frostSpear)
        SpellStore.add(spell: inferno)
    }
}
