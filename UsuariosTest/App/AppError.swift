//
//  AppError.swift
//  UsuariosTest
//
//  Created by: Bruno Cardenas.
//

import Foundation

enum AppError: LocalizedError {
    case invalidForm(String)
    case missingLocationPermission
    case locationUnavailable
    case userNotFound
    case networkUnavailable

    var errorDescription: String? {
        switch self {
        case .invalidForm(let message): message
        case .missingLocationPermission: String(localized: "error_location_permission")
        case .locationUnavailable: String(localized: "error_location_unavailable")
        case .userNotFound: String(localized: "error_user_not_found")
        case .networkUnavailable: String(localized: "error_network")
        }
    }
}
