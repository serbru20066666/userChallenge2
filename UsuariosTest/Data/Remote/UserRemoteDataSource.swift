//
//  UserRemoteDataSource.swift
//  UsuariosTest
//
//  Created by: Bruno Cardenas.
//

import Alamofire
import Foundation

final class UserRemoteDataSource: UserRemoteDataSourceProtocol {
    private let baseURL = "https://jsonplaceholder.typicode.com/users"

    func fetchUsers() async throws -> [User] {
        try await AF.request(baseURL)
            .validate()
            .serializingDecodable([UserDTO].self)
            .value
            .map(\.domain)
    }

    func create(_ user: User) async throws {
        _ = try await AF.request(baseURL, method: .post, parameters: body(user), encoder: JSONParameterEncoder.default)
            .validate()
            .serializingData()
            .value
    }

    func update(_ user: User) async throws {
        _ = try await AF.request("\(baseURL)/\(user.id)", method: .put, parameters: body(user), encoder: JSONParameterEncoder.default)
            .validate()
            .serializingData()
            .value
    }

    func delete(id: Int) async throws {
        _ = try await AF.request("\(baseURL)/\(id)", method: .delete)
            .validate()
            .serializingData()
            .value
    }

    private func body(_ user: User) -> [String: String] {
        ["name": user.name, "username": user.username, "email": user.email, "phone": user.phone]
    }
}
