//
//  RealmUserObject.swift
//  UsuariosTest
//
//  Created by: Bruno Cardenas.
//

import Foundation
import RealmSwift

final class RealmUserObject: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var username = ""
    @Persisted var name = ""
    @Persisted var email = ""
    @Persisted var phone = ""
    @Persisted var city = ""
    @Persisted var latitude: Double?
    @Persisted var longitude: Double?
    @Persisted var isDeleted = false

    convenience init(user: User, isDeleted: Bool = false) {
        self.init()
        id = user.id
        username = user.username
        name = user.name
        email = user.email
        phone = user.phone
        city = user.city
        latitude = user.latitude
        longitude = user.longitude
        self.isDeleted = isDeleted
    }

    var domain: User {
        User(id: id, username: username, name: name, email: email, phone: phone, city: city, latitude: latitude, longitude: longitude)
    }
}
