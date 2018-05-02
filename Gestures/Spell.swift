//
//  Spell.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 02/05/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

class SpellImageStore: NSObject {
    static let images = [#imageLiteral(resourceName: "fireball"), #imageLiteral(resourceName: "frostGrasp"), #imageLiteral(resourceName: "inferno")]
    static let defaultImage = #imageLiteral(resourceName: "nothing")
}

class Spell: NSObject {
    private(set) var id = ""
    private(set) var name = ""
    private(set) var damage: Double = 0
    private(set) var imageIndex = 0
    private(set) var damageType = DamageType.fire
    private(set) var glyph = Glyph.testGlyph
    var image: UIImage {
        return imageIndex < SpellImageStore.images.count ? SpellImageStore.images[imageIndex] : SpellImageStore.defaultImage
    }
    var unlocked = false
    
    convenience init(name: String, damageType: DamageType, damage: Double, glyph: Glyph, imageIndex: Int, id: String? = nil, unlocked: Bool? = false) {
        self.init()
        
        if let id = id {
            self.id = id
        } else {
            self.id = UUID().uuidString + name
        }
        
        if let unlocked = unlocked {
            self.unlocked = unlocked
        } 
        
        self.name = name
        self.damageType = damageType
        self.damage = damage
        self.glyph = glyph
        self.imageIndex = imageIndex
    }
}
