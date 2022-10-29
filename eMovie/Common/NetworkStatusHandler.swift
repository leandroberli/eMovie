//
//  NetworkStatusHandler.swift
//  eMovie
//
//  Created by Leandro Berli on 29/10/2022.
//

import Foundation
import Network

class NetworkStatusHandler {
    
    static let shared = NetworkStatusHandler()
    let monitor = NWPathMonitor()
    var connectionAvailable = true
    
    func startMonitor() {
        monitor.pathUpdateHandler = { path in
            self.connectionAvailable = path.status == .satisfied ? true : false
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
    
}
