//
//  AppContainer.swift
//  UsuariosTest
//
//  Created by: Bruno Cardenas.
//

import Foundation

final class AppContainer {
    private let networkMonitor: NetworkMonitoring
    private let localDataSource: UserLocalDataSourceProtocol
    private let remoteDataSource: UserRemoteDataSourceProtocol
    let locationManager: LocationManaging

    lazy var userRepository: UserRepositoryProtocol = UserRepository(
        remote: remoteDataSource,
        local: localDataSource,
        network: networkMonitor
    )

    lazy var getUsersUseCase = GetUsersUseCase(repository: userRepository)
    lazy var createUserUseCase = CreateUserUseCase(repository: userRepository)
    lazy var updateUserUseCase = UpdateUserUseCase(repository: userRepository)
    lazy var deleteUserUseCase = DeleteUserUseCase(repository: userRepository)

    init() {
        networkMonitor = NetworkMonitorManager()
        localDataSource = RealmUserLocalDataSource()
        remoteDataSource = UserRemoteDataSource()
        locationManager = LocationManager()
    }
}
