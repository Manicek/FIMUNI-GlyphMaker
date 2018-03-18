//
//  Spell.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 18/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import RealmSwift

class Spell: Object {
    dynamic var id = ""
    dynamic var name = ""
    dynamic var damage: Double = 0
    private dynamic var damageTypeRaw = DamageType.fire.rawValue
    var damageType: DamageType {
        get { return DamageType(rawValue: damageTypeRaw)! }
        set { damageTypeRaw = damageType.rawValue }
    }
    dynamic var unlocked = false
    
    convenience init(name: String, damageType: DamageType, damage: Double) {
        self.init()
        
        self.id = UUID().uuidString + name
        self.name = name
        self.damageType = damageType
        self.damage = damage
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static func createBasicSpells() {
        let fireball = Spell(name: "Fireball", damageType: .fire, damage: 50)
        fireball.unlocked = true
        
        let frostSpear = Spell(name: "Frost Spear", damageType: .cold, damage: 40)
        frostSpear.unlocked = true
        
        let fireStorm = Spell(name: "Firestorm", damageType: .fire, damage: 110)
        
        SpellStore.add(Spell: fireball)
        SpellStore.add(Spell: frostSpear)
        SpellStore.add(Spell: fireStorm)
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
