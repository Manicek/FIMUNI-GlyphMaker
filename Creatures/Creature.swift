//
//  Creature.swift
//  CreatureMaker
//
//  Created by Patrik Hora on 18/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import RealmSwift

enum DamageType: Int {
    case fire = 0
    case cold = 1
}

enum CreatureType: Int {
    case beardedDragon = 0
    case wolf = 1
    
    func healthForLevel(_ level: Int) -> Double {
        return baseHealth * Double(level)
    }
    
    var baseHealth: Double {
        switch self {
        case .beardedDragon: return 20
        case .wolf: return 10
        }
    }
    
    var fireResistance: Double {
        switch self {
        case .beardedDragon: return 75
        case .wolf: return 0
        }
    }
    
    var coldResistance: Double {
        switch self {
        case .beardedDragon:
            return 75
        case .wolf:
            return 0
        }
    }
}

class Creature: Object {
    dynamic var id = ""
    dynamic var name = ""
    private dynamic var typeRaw = CreatureType.wolf.rawValue
    var type: CreatureType {
        get { return CreatureType(rawValue: typeRaw)! }
        set { typeRaw = type.rawValue }
    }
    dynamic var health: Double = 100
    dynamic var level = 1
    
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
    }
    
    override static func primaryKey() -> String? {
        return "id"
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

