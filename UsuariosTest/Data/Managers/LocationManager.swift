//
//  LocationManager.swift
//  UsuariosTest
//
//  Created by: Bruno Cardenas.
//

import CoreLocation
import Foundation

final class LocationManager: NSObject, LocationManaging, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private var continuation: CheckedContinuation<UserCoordinate, Error>?
    private var authorizationContinuation: CheckedContinuation<Void, Error>?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.allowsBackgroundLocationUpdates = false
    }

    func currentLocation() async throws -> UserCoordinate {
        if manager.authorizationStatus == .notDetermined {
            try await requestAuthorization()
        }
        guard manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways else {
            throw AppError.missingLocationPermission
        }

        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            manager.requestLocation()
        }
    }

    private func requestAuthorization() async throws {
        try await withCheckedThrowingContinuation { continuation in
            authorizationContinuation = continuation
            manager.requestWhenInUseAuthorization()
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            authorizationContinuation?.resume()
            authorizationContinuation = nil
        case .denied, .restricted:
            authorizationContinuation?.resume(throwing: AppError.missingLocationPermission)
            authorizationContinuation = nil
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            continuation?.resume(throwing: AppError.locationUnavailable)
            continuation = nil
            return
        }
        continuation?.resume(returning: UserCoordinate(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
        continuation = nil
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        continuation?.resume(throwing: error)
        continuation = nil
    }
}
