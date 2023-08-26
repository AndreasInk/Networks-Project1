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
    @Published var url: URL?
    func sendAllRequests(numberOfRequests: Int, command: String) {
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
struct ServerState: Codable, Hashable {
    static func == (lhs: ServerState, rhs: ServerState) -> Bool {
        return lhs.dateTime == rhs.dateTime
    }
    
    var dateTime: Date
    var upTime: TimeInterval
    var memoryUsage: Int
    var networkConnections: NetworkConnections
    var currentUsers: CurrentUser
    var runningProcesses: RunningProcesses
    
    static let empty = ServerState(dateTime: Date.distantPast, upTime: 0, memoryUsage: 0, networkConnections: .empty, currentUsers: .empty, runningProcesses: .empty)
}
struct NetworkConnections: Codable, Hashable {
    var name: String
    var ip: Int
    var isConnected: Bool
    static let empty = NetworkConnections(name: "", ip: 0, isConnected: false)
}
struct RunningProcesses: Codable, Hashable {
    var name: String
    var ip: Int
    var isConnected: Bool
    static let empty = RunningProcesses(name: "", ip: 0, isConnected: false)
}
struct CurrentUser: Codable, Hashable {
    var name: String
    var ip: Int
    var isConnected: Bool
    static let empty = CurrentUser(name: "", ip: 0, isConnected: false)
}
enum ServerCommand: String, CaseIterable {
    case dateTime
    case upTime
    case memoryUsage
    case networkConnections
    case currentUsers
    case runningProcesses
}
