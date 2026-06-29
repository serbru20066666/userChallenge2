//
//  UpdateUserUseCase.swift
//  UsuariosTest
//
//  Created by: Bruno Cardenas.
//

import Foundation

struct UpdateUserUseCase {
    let repository: UserRepositoryProtocol

    func execute(_ user: User) async throws -> User {
        try await repository.update(user)
    }
}
