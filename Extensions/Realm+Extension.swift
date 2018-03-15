//
//  Realm+Extension.swift
//  alberta
//
//  Created by Patrik Hora on 13/12/2017.
//  Copyright © 2017 Master Internet, s.r.o. All rights reserved.
//

import RealmSwift

extension Realm {
    
    class func defaultRealm() -> Realm? {
        let realm: Realm?
        
        do {
            realm = try Realm()
        } catch let error as NSError {
            realm = nil
            log.error("Failed to initialize a default Realm instance with error: \(error.description)")
        }
        
        return realm
    }
    
    func safeDelete(_ object: Object) {
        do {
            try write {
                delete(object)
            }
        } catch let error as NSError {
            log.error(error.description)
        }
    }
    
    func safeDelete<S: Sequence>(_ objects: S) where S.Iterator.Element: Object {
        do {
            try write {
                delete(objects)
            }
        } catch let error as NSError {
            log.error(error.description)
        }
    }
    
    func safeAdd(_ object: Object, update: Bool = false) {
        do {
            try write {
                add(object, update: update)
            }
        } catch let error as NSError {
            log.error(error.description)
        }
    }
    
    func safeAdd<S: Sequence>(_ objects: S, update: Bool = false) where S.Iterator.Element: Object {
        do {
            try write {
                add(objects, update: update)
            }
        } catch let error as NSError {
            log.error(error.description)
        }
    }
}
