//
//  UserListViewModel.swift
//  UsuariosTest
//
//  Created by: Bruno Cardenas.
//

import Foundation
import Combine

@MainActor
final class UserListViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var query = ""
    @Published var isLoading = false
    @Published var message: String?

    private let getUsers: GetUsersUseCase
    private let deleteUser: DeleteUserUseCase

    var filteredUsers: [User] {
        guard !query.isEmpty else { return users }
        return users.filter { [$0.name, $0.username, $0.email, $0.city].joined(separator: " ").localizedCaseInsensitiveContains(query) }
    }

    init(getUsers: GetUsersUseCase, deleteUser: DeleteUserUseCase) {
        self.getUsers = getUsers
        self.deleteUser = deleteUser
    }

    func load(forceRefresh: Bool = false) async {
        let shouldShowShimmer = users.isEmpty || forceRefresh
        let start = Date()
        isLoading = shouldShowShimmer
        do { users = try await getUsers.execute(forceRefresh: forceRefresh) }
        catch { message = error.localizedDescription }
        if shouldShowShimmer {
            let remaining = max(0, 1 - Date().timeIntervalSince(start))
            try? await Task.sleep(nanoseconds: UInt64(remaining * 1_000_000_000))
        }
        isLoading = false
    }

    func delete(at offsets: IndexSet) {
        let ids = offsets.map { filteredUsers[$0].id }
        Task {
            do {
                for id in ids { try await deleteUser.execute(id: id) }
                await load(forceRefresh: false)
            } catch {
                message = error.localizedDescription
            }
        }
    }
}
