//
//  GetUsersUseCase.swift
//  UsuariosTest
//
//  Created by: Bruno Cardenas.
//

import Foundation

struct GetUsersUseCase {
    let repository: UserRepositoryProtocol

    func execute(forceRefresh: Bool = false) async throws -> [User] {
        try await repository.users(forceRefresh: forceRefresh)
    }
}
