//
//  Spell.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 18/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import RealmSwift

class SpellImageStore: NSObject {
    static let images = [#imageLiteral(resourceName: "fireball"), #imageLiteral(resourceName: "frostGrasp"), #imageLiteral(resourceName: "inferno")]
    static let defaultImage = #imageLiteral(resourceName: "nothing")
}

class Spell: Object {
    dynamic var id = ""
    dynamic var name = ""
    dynamic var damage: Double = 0
    dynamic var imageIndex = 0
    var image: UIImage {
        return imageIndex < SpellImageStore.images.count ? SpellImageStore.images[imageIndex] : SpellImageStore.defaultImage
    }
    private dynamic var damageTypeRaw = DamageType.fire.rawValue
    var damageType: DamageType {
        get { return DamageType(rawValue: damageTypeRaw)! }
        set { damageTypeRaw = newValue.rawValue }
    }
    dynamic var glyph: Glyph? = nil
    dynamic var unlocked = false
    
    convenience init(name: String, damageType: DamageType, damage: Double, glyph: Glyph, imageIndex: Int) {
        self.init()
        
        self.id = UUID().uuidString + name
        self.name = name
        self.damageType = damageType
        self.damage = damage
        self.glyph = glyph
        self.imageIndex = imageIndex
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static func createBasicSpells() {
        let fireball = Spell(name: "Fireball", damageType: .fire, damage: 50, glyph: Glyph.generateDeterministicRandomGlyph(.easy, variant: 0), imageIndex: 0)
        fireball.unlocked = true
        
        let frostSpear = Spell(name: "Frost Grasp", damageType: .cold, damage: 40, glyph: Glyph.generateDeterministicRandomGlyph(.easy, variant: 1), imageIndex: 1)
        frostSpear.unlocked = true
        
        let inferno = Spell(name: "Inferno", damageType: .fire, damage: 110, glyph: Glyph.generateDeterministicRandomGlyph(.hard, variant: 0), imageIndex: 2)
        
        SpellStore.add(Spell: fireball)
        SpellStore.add(Spell: frostSpear)
        SpellStore.add(Spell: inferno)
    }
}

struct SpellStore {
    
    static func deleteAllSpells() {
        guard let realm = Realm.defaultRealm() else { return }
        
        realm.safeDelete(realm.objects(Spell.self))
    }
    
    static func getAllSpells() -> Results<Spell>? {
        guard let realm = Realm.defaultRealm() else { return nil }
        
        return realm.objects(Spell.self)
    }
    
    static func getAllUnlockedSpells() -> Results<Spell>? {
        guard let realm = Realm.defaultRealm() else { return nil }

        return realm.objects(Spell.self).filter("unlocked == true")
    }
    
    static func getSpells(ofType type: DamageType) -> Results<Spell>? {
        guard let realm = Realm.defaultRealm() else { return nil }
        
        return realm.objects(Spell.self).filter("damageTypeRaw == \(type.rawValue)")
    }
    
    static func add(Spell: Spell) {
        guard let realm = Realm.defaultRealm() else { return }
        
        realm.safeAdd(Spell)
    }
    
    static func delete(spell: Spell) {
        guard let realm = Realm.defaultRealm() else { return }
        
        realm.safeDelete(spell)
    }
}
