//
//  Creature.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 02/05/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

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

class Creature: NSObject {
    
    private(set) var id = ""
    private(set) var name = ""
    private(set) var type = CreatureType.wolf
    private(set) var level = 1
    private(set) var health: Double = 100
    private(set) var maxHealth: Double = 100
    private(set) var alive = true
    
    convenience init(name: String, type: CreatureType, level: Int, id: String? = nil) {
        self.init()
        
        if let id = id {
            self.id = id
        } else {
            self.id = UUID().uuidString + name
        }
        
        self.name = name
        self.type = type
        self.level = level > 0 ? level : 1
        self.health = type.healthForLevel(self.level)
        self.maxHealth = health
    }
    
    func resistance(from damageType: DamageType) -> Double {
        switch damageType {
        case .fire: return type.fireResistance
        case .cold: return type.coldResistance
        }
    }
    
    func receiveDamage(_ damage: Double, ofType damageType: DamageType) -> Double {
        let finalDamage = damage * (1 - resistance(from: damageType))
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
