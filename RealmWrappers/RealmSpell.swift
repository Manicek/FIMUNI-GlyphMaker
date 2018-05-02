//
//  Spell.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 18/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import RealmSwift

class RealmSpell: Object {
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc dynamic var damage: Double = 0
    @objc dynamic var imageIndex = 0
    var image: UIImage {
        return imageIndex < SpellImageStore.images.count ? SpellImageStore.images[imageIndex] : SpellImageStore.defaultImage
    }
    @objc private dynamic var damageTypeRaw = DamageType.fire.rawValue
    var damageType: DamageType {
        get { return DamageType(rawValue: damageTypeRaw)! }
        set { damageTypeRaw = newValue.rawValue }
    }
    @objc dynamic var glyph: RealmGlyph? = nil
    @objc dynamic var unlocked = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(from spell: Spell) {
        self.init()
        
        self.id = spell.id
        self.name = spell.name
        self.damage = spell.damage
        self.imageIndex = spell.imageIndex
        self.damageType = spell.damageType
        self.glyph = RealmGlyph(from: spell.glyph)
        self.unlocked = spell.unlocked
    }
    
    func toSpell() -> Spell {
        return Spell(name: name, damageType: damageType, damage: damage, glyph: glyph!.toGlyph(), imageIndex: imageIndex, id: id, unlocked: unlocked)
    }
}

struct SpellStore {
    
    static func deleteAllSpells() {
        guard let realm = Realm.defaultRealm() else { return }
        
        realm.safeDelete(realm.objects(RealmSpell.self))
    }
    
    static func getAllSpells() -> [Spell] {
        guard let realm = Realm.defaultRealm() else { return [] }
        
        var results = [Spell]()
        for realmSpell in realm.objects(RealmSpell.self) {
            results.append(realmSpell.toSpell())
        }
        return results
    }
    
    static func getAllUnlockedSpells() -> [Spell] {
        guard let realm = Realm.defaultRealm() else { return [] }
        var results = [Spell]()
        for realmSpell in realm.objects(RealmSpell.self).filter("unlocked == true") {
            results.append(realmSpell.toSpell())
        }
        return results
    }
    
    static func getSpells(ofType type: DamageType) -> [Spell] {
        guard let realm = Realm.defaultRealm() else { return [] }
        var results = [Spell]()
        for realmSpell in realm.objects(RealmSpell.self).filter("damageTypeRaw == \(type.rawValue)") {
            results.append(realmSpell.toSpell())
        }
        return results
    }
    
    static func add(spell: Spell) {
        guard let realm = Realm.defaultRealm() else { return }
        
        realm.safeAdd(RealmSpell(from: spell))
    }
    
    static func delete(spell: RealmSpell) {
        guard let realm = Realm.defaultRealm() else { return }
        
        realm.safeDelete(spell)
    }
}
