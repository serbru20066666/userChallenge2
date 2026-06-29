//
//  UserRepository.swift
//  UsuariosTest
//
//  Created by: Bruno Cardenas.
//

import Foundation

final class UserRepository: UserRepositoryProtocol {
    private let remote: UserRemoteDataSourceProtocol
    private let local: UserLocalDataSourceProtocol
    private let network: NetworkMonitoring

    init(remote: UserRemoteDataSourceProtocol, local: UserLocalDataSourceProtocol, network: NetworkMonitoring) {
        self.remote = remote
        self.local = local
        self.network = network
    }

    func users(forceRefresh: Bool) async throws -> [User] {
        let cached = try local.users(includeDeleted: false)
        guard forceRefresh || cached.isEmpty else { return cached }
        guard network.isConnected else { return cached }
        do {
            let remoteUsers = try await remote.fetchUsers()
            try local.upsert(remoteUsers)
            return try local.users(includeDeleted: false)
        } catch {
            if cached.isEmpty { throw error }
            return cached
        }
    }

    func create(_ user: User) async throws -> User {
        if network.isConnected { try await remote.create(user) }
        let saved = user.withGeneratedID()
        try local.save(saved, isDeleted: false)
        return saved
    }

    func update(_ user: User) async throws -> User {
        if network.isConnected { try await remote.update(user) }
        try local.save(user, isDeleted: false)
        return user
    }

    func delete(id: Int) async throws {
        if network.isConnected { try await remote.delete(id: id) }
        try local.markDeleted(id: id)
    }
}

private extension User {
    func withGeneratedID() -> User {
        var copy = self
        copy.username = copy.username.isEmpty ? copy.email.components(separatedBy: "@").first ?? copy.name : copy.username
        copy.city = copy.city.isEmpty ? "Local" : copy.city
        return User(
            id: Int(Date().timeIntervalSince1970 * 1000),
            username: copy.username,
            name: copy.name,
            email: copy.email,
            phone: copy.phone,
            city: copy.city,
            latitude: copy.latitude,
            longitude: copy.longitude
        )
    }
}
