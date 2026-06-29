//
//  UserDTO.swift
//  UsuariosTest
//
//  Created by: Bruno Cardenas.
//

import Foundation

struct UserDTO: Codable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let phone: String
    let address: AddressDTO?

    struct AddressDTO: Codable {
        let city: String
        let geo: GeoDTO?
    }

    struct GeoDTO: Codable {
        let lat: String
        let lng: String
    }

    var domain: User {
        User(
            id: id,
            username: username,
            name: name,
            email: email,
            phone: phone,
            city: address?.city ?? "",
            latitude: Double(address?.geo?.lat ?? ""),
            longitude: Double(address?.geo?.lng ?? "")
        )
    }
}
