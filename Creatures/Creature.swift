//
//  Creature.swift
//  CreatureMaker
//
//  Created by Patrik Hora on 18/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import RealmSwift

enum CreatureType: Int {
    case beardedDragon = 0
    case wolf = 1
    
    static let allValues: [CreatureType] = [.beardedDragon, .wolf]
    
    func healthForLevel(_ level: Int) -> Double {
        return baseHealth * Double(level)
    }
    
    var image: UIImage {
        switch self {
        case .beardedDragon: return #imageLiteral(resourceName: "beardedDragon1")
        case .wolf: return #imageLiteral(resourceName: "wolf")
        }
    }
    
    var baseHealth: Double {
        switch self {
        case .beardedDragon: return 150
        case .wolf: return 100
        }
    }
    
    var fireResistance: Double {
        switch self {
        case .beardedDragon: return 0.75
        case .wolf: return 0
        }
    }
    
    var coldResistance: Double {
        switch self {
        case .beardedDragon: return 0
        case .wolf: return 0.20
        }
    }
}

class Creature: Object {
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
    
    var fireResistance: Double {
        return type.fireResistance
    }
    
    var coldResistance: Double {
        return type.coldResistance
    }

    convenience init(name: String, type: CreatureType, level: Int) {
        self.init()
        
        self.id = UUID().uuidString + name
        self.name = name
        self.type = type
        self.level = level > 0 ? level : 1
        self.health = type.healthForLevel(self.level)
        self.maxHealth = health
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func receiveDamage(_ damage: Double, ofType type: DamageType) -> Double {
        var resistance = 0.0
        switch type {
        case .fire: resistance = fireResistance
        case .cold: resistance = coldResistance
        }
        let finalDamage = damage * (1 - resistance)
        health -= finalDamage
        if health <= 0 {
            health = 0
            alive = false
        }
        
        return finalDamage
    }
    
    static let testCreature = Creature(name: "Test", type: .wolf, level: 1)
    
    static func getRandomCreature() -> Creature {
        return Creature(name: "",
                        type: CreatureType(rawValue: Utils.randomInt(CreatureType.allValues.count))!,
                        level: Utils.randomInt(3))
    }
}

struct CreatureStore {
    
    static func deleteAllCreatures() {
        guard let realm = Realm.defaultRealm() else { return }
        
        realm.safeDelete(realm.objects(Creature.self))
    }
    
    static func getAllCreatures() -> Results<Creature>? {
        guard let realm = Realm.defaultRealm() else { return nil }
        
        return realm.objects(Creature.self)
    }
    
    static func add(creature: Creature) {
        guard let realm = Realm.defaultRealm() else { return }
        
        realm.safeAdd(creature)
    }
    
    static func delete(creature: Creature) {
        guard let realm = Realm.defaultRealm() else { return }
        
        realm.safeDelete(creature)
    }
}
