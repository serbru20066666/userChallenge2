//
//  UserFormViewModelTests.swift
//  UsuariosTestTests
//
//  Created by: Bruno Cardenas.
//

import XCTest
@testable import UsuariosTest

@MainActor
final class UserFormViewModelTests: XCTestCase {
    func testInvalidEmailDoesNotSaveUser() async {
        let repository = UserRepositoryMock()
        let viewModel = UserFormViewModel(
            createUser: CreateUserUseCase(repository: repository),
            locationManager: LocationManagerMock()
        )
        viewModel.name = "Bruno"
        viewModel.email = "correo-invalido"
        viewModel.phone = "999999999"

        await viewModel.save()

        XCTAssertFalse(viewModel.didSave)
        XCTAssertEqual(repository.createdUsers.count, 0)
        XCTAssertEqual(viewModel.message, String(localized: "validation_email"))
    }

    func testValidFormCreatesUser() async {
        let repository = UserRepositoryMock()
        let viewModel = UserFormViewModel(
            createUser: CreateUserUseCase(repository: repository),
            locationManager: LocationManagerMock()
        )
        viewModel.name = "Bruno"
        viewModel.email = "bruno@test.com"
        viewModel.phone = "999999999"

        await viewModel.save()

        XCTAssertTrue(viewModel.didSave)
        XCTAssertEqual(repository.createdUsers.first?.email, "bruno@test.com")
    }
}
