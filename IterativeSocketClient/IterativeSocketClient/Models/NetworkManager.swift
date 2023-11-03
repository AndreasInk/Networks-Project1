//
//  NetworkManager.swift
//  IterativeSocketClient
//
//  Created by Andreas Ink on 8/26/23.
//

import SwiftUI

class NetworkManager: ObservableObject {
    
    @Published var serverStateHistory: [Date: ServerState] = [:]
    @Published var url: URL = URL(string: "http://127.0.0.1:3216")!//URL(string: "http://139.62.210.155:3215")!
    
    let decoder = JSONDecoder()
    
    @MainActor func sendRequests(numberOfRequests: Int, command: ServerCommand) {
        let date = Date()
        for _ in 0...numberOfRequests {
            Task {
                let session = URLSession(configuration: .default)
                session.configuration.timeoutIntervalForRequest = 25
                let data = try await session.data(from: url.appending(path: command.rawValue))
                print(String(data: data.0, encoding: .utf8))
                decoder.dateDecodingStrategy = .secondsSince1970
                if serverStateHistory[date] == nil {
                    serverStateHistory[date] = .empty
                }
                var currentSeverState = ServerState.empty
                switch command {
                case .dateTime:
                    try await MainActor.run {
                        currentSeverState.dateTime = try decoder.decode(DateTime.self, from: data.0).dateTime
                    }
                case .upTime:
                    try await MainActor.run {
                        currentSeverState.upTime = try decoder.decode(UpTime.self, from: data.0).upTime
                    }
                case .memoryUsage:
                    try await MainActor.run {
                        currentSeverState.memoryUsage = Int(try decoder.decode(MemoryUsage.self, from: data.0).memoryUsage)
                    }
                case .networkConnections:
                    try await MainActor.run {
                        currentSeverState.networkConnections = try decoder.decode([NetworkConnection].self, from: data.0)
                    }
                case .currentUsers:
                    currentSeverState.currentUsers = try decoder.decode([CurrentUser].self, from: data.0)
                case .runningProcesses:
                    currentSeverState.runningProcesses = try decoder.decode([RunningProcess].self, from: data.0)
                }
                currentSeverState.turnAroundTime = date.distance(to: Date())
                serverStateHistory[date] = currentSeverState
                
            }
        }
    }
}
