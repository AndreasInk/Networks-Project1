//
//  NetworkManager.swift
//  IterativeSocketClient
//
//  Created by Andreas Ink on 8/26/23.
//

import SwiftUI

class NetworkManager: ObservableObject {
    
    @MainActor @Published var currentSeverState: ServerState?
    @Published var serverStateHistory: [ServerState] = []
    @Published var url: URL = URL(string: "http://127.0.0.1:5000/")!
    
    let decoder = JSONDecoder()
    func sendAllRequests(numberOfRequests: Int, command: ServerCommand) {
        for _ in 0...numberOfRequests {
            for command in ServerCommand.allCases {
                Task {
                    let session = URLSession.shared
                    session.configuration.timeoutIntervalForRequest = 60 * 60
                    let data = try await session.data(from: url.appending(path: command.rawValue))
                    print(String(data: data.0, encoding: .utf8))
                    
                    decoder.dateDecodingStrategy = .secondsSince1970
                    switch command {
                    case .dateTime:
                        try await MainActor.run {
                            currentSeverState?.dateTime = try decoder.decode(Date.self, from: data.0)
                        }
                    case .upTime:
                        try await MainActor.run {
                            currentSeverState?.upTime = try decoder.decode(Date.self, from: data.0).timeIntervalSince1970
                        }
                    case .memoryUsage:
                        break
                    case .networkConnections:
                        print(String(data: data.0, encoding: .utf8))
                        break
                    case .currentUsers:
                        break
                    case .runningProcesses:
                        break
                    }
                    
                }
            }
        }
    }
    func sendRequest() {
        Task {
            let startDate = Date()
            let session = URLSession.shared
            session.configuration.timeoutIntervalForRequest = 60 * 60
            let data = try await session.data(from: url.appending(path: ServerCommand.networkConnections.rawValue))
            print(String(data: data.0, encoding: .utf8))
            let networkConnections = try decoder.decode([NetworkConnection].self, from: data.0)
            serverStateHistory.append(ServerState(dateTime: Date(), upTime: 0, memoryUsage: 0, networkConnections: networkConnections, currentUsers: [], runningProcesses: [], turnAroundTime: startDate.distance(to: Date())))
            
        }
    }
}
