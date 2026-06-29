//
//  DeleteUserUseCase.swift
//  UsuariosTest
//
//  Created by: Bruno Cardenas.
//

import Foundation

struct DeleteUserUseCase {
    let repository: UserRepositoryProtocol

    func execute(id: Int) async throws {
        try await repository.delete(id: id)
    }
}
