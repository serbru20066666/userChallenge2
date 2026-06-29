//
//  RealmUserLocalDataSource.swift
//  UsuariosTest
//
//  Created by: Bruno Cardenas.
//

import Foundation
import RealmSwift

final class RealmUserLocalDataSource: UserLocalDataSourceProtocol {
    func users(includeDeleted: Bool = false) throws -> [User] {
        let realm = try Realm()
        let objects = includeDeleted ? realm.objects(RealmUserObject.self) : realm.objects(RealmUserObject.self).where { !$0.isDeleted }
        return objects.sorted(byKeyPath: "name").map(\.domain)
    }

    func upsert(_ users: [User]) throws {
        let deleted = try deletedIDs()
        let realm = try Realm()
        try realm.write {
            users.filter { !deleted.contains($0.id) }.forEach { realm.add(RealmUserObject(user: $0), update: .modified) }
        }
    }

    func save(_ user: User, isDeleted: Bool = false) throws {
        let realm = try Realm()
        try realm.write {
            realm.add(RealmUserObject(user: user, isDeleted: isDeleted), update: .modified)
        }
    }

    func markDeleted(id: Int) throws {
        let realm = try Realm()
        try realm.write {
            if let object = realm.object(ofType: RealmUserObject.self, forPrimaryKey: id) {
                object.isDeleted = true
            } else {
                let deleted = RealmUserObject(user: User(id: id, username: "", name: "", email: "", phone: "", city: "", latitude: nil, longitude: nil), isDeleted: true)
                realm.add(deleted, update: .modified)
            }
        }
    }

    func deletedIDs() throws -> Set<Int> {
        let realm = try Realm()
        return Set(realm.objects(RealmUserObject.self).where { $0.isDeleted }.map(\.id))
    }
}
