//
//  UserListView.swift
//  UsuariosTest
//
//  Created by: Bruno Cardenas.
//

import SwiftUI

struct UserListView: View {
    @StateObject var viewModel: UserListViewModel
    var usesLegacyNavigation = false
    @EnvironmentObject private var coordinator: AppCoordinator

    var body: some View {
        List {
            if viewModel.isLoading {
                ForEach(0..<6, id: \.self) { _ in LoadingUserRow() }
            } else {
                ForEach(viewModel.filteredUsers) { user in
                    Button { coordinator.showDetail(id: user.id) } label: {
                        UserRowView(user: user)
                    }
                    .buttonStyle(.plain)
                }
                .onDelete(perform: viewModel.delete)
            }
        }
        .listStyle(.plain)
        .navigationTitle("users_title")
        .searchable(text: $viewModel.query, prompt: "users_search")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button { Task { await viewModel.load(forceRefresh: true) } } label: {
                    Image(systemName: "arrow.clockwise")
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button { coordinator.showCreate() } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .task { await viewModel.load() }
        .background(legacyNavigationLinks)
        .alert("app_message", isPresented: .constant(viewModel.message != nil)) {
            Button("ok") { viewModel.message = nil }
        } message: {
            Text(viewModel.message ?? "")
        }
    }

    @ViewBuilder
    private var legacyNavigationLinks: some View {
        if usesLegacyNavigation {
            NavigationLink(
                "",
                isActive: Binding(
                    get: { coordinator.selectedUserID != nil },
                    set: { if !$0 { coordinator.selectedUserID = nil } }
                )
            ) {
                if let id = coordinator.selectedUserID {
                    UserDetailView(viewModel: UserDetailViewModel(
                        userID: id,
                        getUsers: coordinator.container.getUsersUseCase,
                        updateUser: coordinator.container.updateUserUseCase
                    ))
                }
            }
            NavigationLink("", isActive: $coordinator.isCreating) {
                UserFormView(viewModel: UserFormViewModel(
                    createUser: coordinator.container.createUserUseCase,
                    locationManager: coordinator.container.locationManager
                ))
            }
        }
    }
}
