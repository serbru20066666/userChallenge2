//
//  UserRepositoryProtocol.swift
//  UsuariosTest
//
//  Created by: Bruno Cardenas.
//

import Foundation

protocol UserRepositoryProtocol {
    func users(forceRefresh: Bool) async throws -> [User]
    func create(_ user: User) async throws -> User
    func update(_ user: User) async throws -> User
    func delete(id: Int) async throws
}

protocol UserRemoteDataSourceProtocol {
    func fetchUsers() async throws -> [User]
    func create(_ user: User) async throws
    func update(_ user: User) async throws
    func delete(id: Int) async throws
}

protocol UserLocalDataSourceProtocol {
    func users(includeDeleted: Bool) throws -> [User]
    func upsert(_ users: [User]) throws
    func save(_ user: User, isDeleted: Bool) throws
    func markDeleted(id: Int) throws
    func deletedIDs() throws -> Set<Int>
}

protocol NetworkMonitoring {
    var isConnected: Bool { get }
}

protocol LocationManaging {
    func currentLocation() async throws -> UserCoordinate
}

struct UserCoordinate: Hashable {
    let latitude: Double
    let longitude: Double
}
