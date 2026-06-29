//
//  UserFormViewModel.swift
//  UsuariosTest
//
//  Created by: Bruno Cardenas.
//

import Foundation
import Combine

@MainActor
final class UserFormViewModel: ObservableObject {
    @Published var name = ""
    @Published var email = ""
    @Published var phone = ""
    @Published var coordinate: UserCoordinate?
    @Published var message: String?
    @Published var isLoading = false
    @Published var didSave = false

    private let createUser: CreateUserUseCase
    private let locationManager: LocationManaging

    init(createUser: CreateUserUseCase, locationManager: LocationManaging) {
        self.createUser = createUser
        self.locationManager = locationManager
    }

    func obtainLocation() async {
        do {
            coordinate = try await locationManager.currentLocation()
            if let coordinate {
                message = String(format: String(localized: "location_result"), coordinate.latitude, coordinate.longitude)
            }
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
            _ = try await createUser.execute(User(
                id: 0,
                username: email.components(separatedBy: "@").first ?? name,
                name: name,
                email: email,
                phone: phone,
                city: "Local",
                latitude: coordinate?.latitude,
                longitude: coordinate?.longitude
            ))
            didSave = true
        } catch {
            message = error.localizedDescription
        }
    }

    private func validate() -> String? {
        Validator.firstError(name, rules: [.required(String(localized: "validation_name"))]) ??
        Validator.firstError(email, rules: [.required(String(localized: "validation_email_required")), .email(String(localized: "validation_email"))]) ??
        Validator.firstError(phone, rules: [.required(String(localized: "validation_phone_required")), .phone(String(localized: "validation_phone"))])
    }
}
