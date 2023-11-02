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
    @Published var url: URL = URL(string: "http://127.0.0.1:3216")!//URL(string: "http://139.62.210.155:3215")!
    
    let decoder = JSONDecoder()
    
    @MainActor func sendRequests(numberOfRequests: Int, command: ServerCommand) {
        for _ in 0...numberOfRequests {
            Task {
                let session = URLSession(configuration: .default)
                session.configuration.timeoutIntervalForRequest = 5
                let data = try await session.data(from: url.appending(path: command.rawValue))
                print(String(data: data.0, encoding: .utf8))
                decoder.dateDecodingStrategy = .secondsSince1970

                switch command {
                case .dateTime:
                    try await MainActor.run {
                        currentSeverState?.dateTime = try decoder.decode(DateTime.self, from: data.0).dateTime
                    }
                case .upTime:
                    try await MainActor.run {
                        currentSeverState?.upTime = try decoder.decode(UpTime.self, from: data.0).upTime
                    }
                case .memoryUsage:
                    try await MainActor.run {
                        currentSeverState?.memoryUsage = Int(try decoder.decode(MemoryUsage.self, from: data.0).memoryUsage)
                    }
                case .networkConnections:
                    try await MainActor.run {
                        currentSeverState?.networkConnections = try decoder.decode([NetworkConnection].self, from: data.0)
                    }
                case .currentUsers:
                    currentSeverState?.currentUsers = try decoder.decode([CurrentUser].self, from: data.0)
                case .runningProcesses:
                    currentSeverState?.runningProcesses = try decoder.decode([RunningProcess].self, from: data.0)
                }
            }
        }
        if let currentSeverState {
            serverStateHistory.append(currentSeverState)
        }
    }
    @MainActor func sendAllRequests(numberOfRequests: Int) {
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
                            currentSeverState?.dateTime = try decoder.decode(DateTime.self, from: data.0).dateTime
                        }
                    case .upTime:
                        try await MainActor.run {
                            currentSeverState?.upTime = try decoder.decode(UpTime.self, from: data.0).upTime
                        }
                    case .memoryUsage:
                        try await MainActor.run {
                            currentSeverState?.memoryUsage = Int(try decoder.decode(MemoryUsage.self, from: data.0).memoryUsage)
                        }
                    case .networkConnections:
                        try await MainActor.run {
                            currentSeverState?.networkConnections = try decoder.decode([NetworkConnection].self, from: data.0)
                        }
                    case .currentUsers:
                        currentSeverState?.currentUsers = try decoder.decode([CurrentUser].self, from: data.0)
                    case .runningProcesses:
                        currentSeverState?.runningProcesses = try decoder.decode([RunningProcess].self, from: data.0)
                    }
                    
                }
            }
        }
        if let currentSeverState {
            serverStateHistory.append(currentSeverState)
        }
    }
    func sendRequest() {
        Task {
            let startDate = Date()
            let session = URLSession.shared
            session.configuration.timeoutIntervalForRequest = 5
            do {
                let data = try await session.data(from: url.appending(path: ServerCommand.dateTime.rawValue))
                print(String(data: data.0, encoding: .utf8))
                let dateTime = try decoder.decode(DateTime.self, from: data.0)
                serverStateHistory.append(ServerState(dateTime: dateTime.dateTime, upTime: 0, memoryUsage: 0, networkConnections: [], currentUsers: [], runningProcesses: [], turnAroundTime: startDate.distance(to: Date())))
            } catch {
                print(error)
            }
        }
    }
}
