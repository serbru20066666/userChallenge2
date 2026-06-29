//
//  NetworkMonitorManager.swift
//  UsuariosTest
//
//  Created by: Bruno Cardenas.
//

import Foundation
import Network

final class NetworkMonitorManager: NetworkMonitoring {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitorManager")
    private var connected = true

    var isConnected: Bool { connected }

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.connected = path.status == .satisfied
        }
        monitor.start(queue: queue)
    }

    deinit {
        monitor.cancel()
    }
}
