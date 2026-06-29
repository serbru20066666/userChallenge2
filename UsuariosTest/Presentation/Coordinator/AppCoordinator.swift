//
//  AppCoordinator.swift
//  UsuariosTest
//
//  Created by: Bruno Cardenas.
//

import SwiftUI
import Combine

enum AppRoute: Hashable {
    case detail(Int)
    case create
}

final class AppCoordinator: ObservableObject {
    @Published var path: [AppRoute] = []
    @Published var selectedUserID: Int?
    @Published var isCreating = false
    let container: AppContainer

    init(container: AppContainer = AppContainer()) {
        self.container = container
    }

    func showDetail(id: Int) {
        selectedUserID = id
        path.append(.detail(id))
    }

    func showCreate() {
        isCreating = true
        path.append(.create)
    }

    func pop() {
        selectedUserID = nil
        isCreating = false
        _ = path.popLast()
    }
}

struct AppCoordinatorView: View {
    @StateObject private var coordinator = AppCoordinator()

    var body: some View {
        if #available(iOS 16.0, *) {
            stackNavigation
        } else {
            legacyNavigation
        }
    }

    @available(iOS 16.0, *)
    private var stackNavigation: some View {
        NavigationStack(path: $coordinator.path) {
            UserListView(viewModel: UserListViewModel(
                getUsers: coordinator.container.getUsersUseCase,
                deleteUser: coordinator.container.deleteUserUseCase
            ))
            .environmentObject(coordinator)
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .detail(let id):
                    UserDetailView(viewModel: UserDetailViewModel(
                        userID: id,
                        getUsers: coordinator.container.getUsersUseCase,
                        updateUser: coordinator.container.updateUserUseCase
                    ))
                case .create:
                    UserFormView(viewModel: UserFormViewModel(
                        createUser: coordinator.container.createUserUseCase,
                        locationManager: coordinator.container.locationManager
                    ))
                }
            }
        }
    }

    private var legacyNavigation: some View {
        NavigationView {
            UserListView(
                viewModel: UserListViewModel(
                    getUsers: coordinator.container.getUsersUseCase,
                    deleteUser: coordinator.container.deleteUserUseCase
                ),
                usesLegacyNavigation: true
            )
            .environmentObject(coordinator)
        }
    }
}
