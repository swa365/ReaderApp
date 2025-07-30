//
//  Network.swift
//  ReaderApp
//
//  Created by swaim yadav on 28/07/25.
//

import Foundation

import Network

class NetworkMonitor {
    static let shared = NetworkMonitor()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    private(set) var isConnected: Bool = false
    private(set) var connectionType: NWInterface.InterfaceType?

    private init() {
        monitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied

            if self.isConnected {
                self.connectionType = path.availableInterfaces.filter { path.usesInterfaceType($0.type) }.first?.type
            } else {
                self.connectionType = nil
            }
           // print("Network status: \(self.isConnected ? "Connected" : "Disconnected")")
        }

        monitor.start(queue: queue)
    }
}
