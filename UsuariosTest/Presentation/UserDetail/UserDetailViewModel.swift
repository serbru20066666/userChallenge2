//
//  UserDetailViewModel.swift
//  UsuariosTest
//
//  Created by: Bruno Cardenas.
//

import Foundation
import Combine

@MainActor
final class UserDetailViewModel: ObservableObject {
    @Published var user = User.empty
    @Published var name = ""
    @Published var email = ""
    @Published var message: String?
    @Published var isLoading = false

    private let userID: Int
    private let getUsers: GetUsersUseCase
    private let updateUser: UpdateUserUseCase

    init(userID: Int, getUsers: GetUsersUseCase, updateUser: UpdateUserUseCase) {
        self.userID = userID
        self.getUsers = getUsers
        self.updateUser = updateUser
    }

    func load() async {
        do {
            guard let found = try await getUsers.execute().first(where: { $0.id == userID }) else { throw AppError.userNotFound }
            user = found
            name = found.name
            email = found.email
        } catch {
            message = error.localizedDescription
        }
    }

    func save() async {
        if let error = validate() {
            message = error
            return
        }
        isLoading = true
        defer { isLoading = false }
        do {
            var edited = user
            edited.name = name
            edited.email = email
            user = try await updateUser.execute(edited)
            message = String(localized: "detail_saved")
        } catch {
            message = error.localizedDescription
        }
    }

    private func validate() -> String? {
        Validator.firstError(name, rules: [.required(String(localized: "validation_name"))]) ??
        Validator.firstError(email, rules: [.required(String(localized: "validation_email_required")), .email(String(localized: "validation_email"))])
    }
}
