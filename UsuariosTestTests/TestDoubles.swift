//
//  TestDoubles.swift
//  UsuariosTestTests
//
//  Created by: Bruno Cardenas.
//

import Foundation
@testable import UsuariosTest

final class UserRepositoryMock: UserRepositoryProtocol {
    var storedUsers: [User]
    private(set) var createdUsers: [User] = []

    init(users: [User] = []) {
        storedUsers = users
    }

    func users(forceRefresh: Bool) async throws -> [User] {
        storedUsers
    }

    func create(_ user: User) async throws -> User {
        createdUsers.append(user)
        storedUsers.append(user)
        return user
    }

    func update(_ user: User) async throws -> User {
        if let index = storedUsers.firstIndex(where: { $0.id == user.id }) {
            storedUsers[index] = user
        }
        return user
    }

    func delete(id: Int) async throws {
        storedUsers.removeAll { $0.id == id }
    }
}

struct LocationManagerMock: LocationManaging {
    func currentLocation() async throws -> UserCoordinate {
        UserCoordinate(latitude: -12.0464, longitude: -77.0428)
    }
}
