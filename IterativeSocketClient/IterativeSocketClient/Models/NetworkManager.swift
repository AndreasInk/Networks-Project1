//
//  NetworkManager.swift
//  IterativeSocketClient
//
//  Created by Andreas Ink on 8/26/23.
//

import SwiftUI

class NetworkManager: ObservableObject {
    @Published var currentSeverState: ServerState?
    @Published var severStateHistory: [ServerState] = []
    @Published var url: URL? = URL(string: "http://localhost:5000/")!
    func sendAllRequests(numberOfRequests: Int, command: ServerCommand) {
        if let url {
            for _ in 0...numberOfRequests {
                for command in ServerCommand.allCases {
                    Task {
                        let session = URLSession.shared
                        let data = try await session.data(from: url.appending(path: command.rawValue))
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .secondsSince1970
                        switch command {
                        case .dateTime:
                            currentSeverState?.dateTime = try decoder.decode(Date.self, from: data.0)
                        case .upTime:
                            currentSeverState?.upTime = try decoder.decode(Date.self, from: data.0).timeIntervalSince1970
                        case .memoryUsage:
                            break
                        case .networkConnections:
                            break
                        case .currentUsers:
                            break
                        case .runningProcesses:
                            break
                        }
                        if let currentSeverState {
                            severStateHistory.append(currentSeverState)
                        }
                    }
                }
            }
        }
    }
}
