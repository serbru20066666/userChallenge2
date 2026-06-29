//
//  UserListViewModelTests.swift
//  UsuariosTestTests
//
//  Created by: Bruno Cardenas.
//

import XCTest
@testable import UsuariosTest

@MainActor
final class UserListViewModelTests: XCTestCase {
    func testLoadUsersFillsList() async {
        let repository = UserRepositoryMock(users: [
            User(id: 1, username: "bruno", name: "Bruno Cardenas", email: "bruno@test.com", phone: "999999999", city: "Lima", latitude: nil, longitude: nil)
        ])
        let viewModel = UserListViewModel(
            getUsers: GetUsersUseCase(repository: repository),
            deleteUser: DeleteUserUseCase(repository: repository)
        )

        await viewModel.load()

        XCTAssertEqual(viewModel.users.count, 1)
        XCTAssertEqual(viewModel.users.first?.name, "Bruno Cardenas")
    }

    func testSearchFiltersByCity() async {
        let repository = UserRepositoryMock(users: [
            User(id: 1, username: "ana", name: "Ana Perez", email: "ana@test.com", phone: "111111111", city: "Quito", latitude: nil, longitude: nil),
            User(id: 2, username: "luis", name: "Luis Rojas", email: "luis@test.com", phone: "222222222", city: "Lima", latitude: nil, longitude: nil)
        ])
        let viewModel = UserListViewModel(
            getUsers: GetUsersUseCase(repository: repository),
            deleteUser: DeleteUserUseCase(repository: repository)
        )

        await viewModel.load()
        viewModel.query = "lima"

        XCTAssertEqual(viewModel.filteredUsers.map(\.id), [2])
    }
}
