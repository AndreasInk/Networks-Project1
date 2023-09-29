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
    @Published var url: URL? = URL(string: "http://127.0.0.1:5000/")!
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
struct ServerState: Codable, Hashable {
    static func == (lhs: ServerState, rhs: ServerState) -> Bool {
        return lhs.dateTime == rhs.dateTime
    }
    
    var dateTime: Date
    var upTime: TimeInterval
    var memoryUsage: Int
    var networkConnections: [NetworkConnection]
    var currentUsers: [CurrentUser]
    var runningProcesses: [RunningProcess]
    var lastCommandSent: ServerCommand = .dateTime
    static var empty: ServerState {
        ServerState(dateTime: Date(), upTime: 0, memoryUsage: 0, networkConnections: NetworkConnection.empty, currentUsers: CurrentUser.empty, runningProcesses: RunningProcess.empty)
    }
}
struct NetworkConnection: Codable, Hashable {
    var name: String
    var ip: Int
    var isConnected: Bool
    static let empty = [NetworkConnection(name: "", ip: 0, isConnected: false)]
}
struct RunningProcess: Codable, Hashable {
    var name: String
    var ip: Int
    var isConnected: Bool
    static let empty = [RunningProcess(name: "", ip: 0, isConnected: false)]
}
struct CurrentUser: Codable, Hashable {
    var name: String
    var ip: Int
    var isConnected: Bool
    static let empty = [CurrentUser(name: "", ip: 0, isConnected: false)]
}
enum ServerCommand: String, CaseIterable, Codable {
    case dateTime
    case upTime
    case memoryUsage
    case networkConnections
    case currentUsers
    case runningProcesses
}
