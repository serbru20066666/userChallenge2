//
//  CreateUserUseCase.swift
//  UsuariosTest
//
//  Created by: Bruno Cardenas.
//

import Foundation

struct CreateUserUseCase {
    let repository: UserRepositoryProtocol

    func execute(_ user: User) async throws -> User {
        try await repository.create(user)
    }
}
