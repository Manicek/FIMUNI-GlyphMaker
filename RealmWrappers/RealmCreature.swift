//
//  Creature.swift
//  CreatureMaker
//
//  Created by Patrik Hora on 18/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import RealmSwift

class RealmCreature: Object {
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    @objc private dynamic var typeRaw = CreatureType.wolf.rawValue
    var type: CreatureType {
        get { return CreatureType(rawValue: typeRaw)! }
        set { typeRaw = newValue.rawValue }
    }
    @objc dynamic var maxHealth: Double = 100
    @objc dynamic var health: Double = 100
    @objc dynamic var level = 1
    @objc dynamic var alive = true
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(from creature: Creature) {
        self.init()
        
        self.id = UUID().uuidString
        self.name = creature.name
        self.type = creature.type
        self.maxHealth = creature.maxHealth
        self.health = creature.health
        self.level = creature.level
        self.alive = creature.alive
    }
    
    func toCreature() -> Creature {
        return Creature(name: name, type: type, level: level, id: id)
    }
}

struct CreatureStore {
    
    static func deleteAllCreatures() {
        guard let realm = Realm.defaultRealm() else { return }
        
        realm.safeDelete(realm.objects(RealmCreature.self))
    }
    
    static func getAllCreatures() -> [Creature] {
        guard let realm = Realm.defaultRealm() else { return [] }
        
        var creatures = [Creature]()
        for realmCreature in realm.objects(RealmCreature.self) {
            creatures.append(realmCreature.toCreature())
        }
        return creatures
    }
    
    static func add(creature: RealmCreature) {
        guard let realm = Realm.defaultRealm() else { return }
        
        realm.safeAdd(creature)
    }
    
    static func delete(creature: RealmCreature) {
        guard let realm = Realm.defaultRealm() else { return }
        
        realm.safeDelete(creature)
    }
}
