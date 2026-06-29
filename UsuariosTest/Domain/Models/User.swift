//
//  User.swift
//  UsuariosTest
//
//  Created by: Bruno Cardenas.
//

import Foundation

struct User: Identifiable, Hashable {
    let id: Int
    var username: String
    var name: String
    var email: String
    var phone: String
    var city: String
    var latitude: Double?
    var longitude: Double?

    static let empty = User(id: 0, username: "", name: "", email: "", phone: "", city: "", latitude: nil, longitude: nil)
}
