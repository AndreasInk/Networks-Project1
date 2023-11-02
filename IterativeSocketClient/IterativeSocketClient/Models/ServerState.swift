//
//  ServerState.swift
//  IterativeSocketClient
//
//  Created by Andreas Ink on 9/29/23.
//

import SwiftUI

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
    var turnAroundTime: Double = 0
    var totalTurnAroundTime: Double = 0
    var averageTurnAroundTime: Double = 0
    
    static var empty: ServerState {
        ServerState(dateTime: Date(), upTime: 0, memoryUsage: 0, networkConnections: NetworkConnection.empty, currentUsers: CurrentUser.empty, runningProcesses: RunningProcess.empty)
    }
    
    // Define a mock array of ServerState instances
    static var mockData: [ServerState] {

        let networkConnection1 = NetworkConnection(proto: "", receiveQueue: "", sendQueue: "", localAddress: "", foreignAddress: "", state: "")
        let networkConnection2 = NetworkConnection(proto: "", receiveQueue: "", sendQueue: "", localAddress: "", foreignAddress: "", state: "")
        let currentUser1 = CurrentUser(name: "User1", ip: 1921683, isConnected: true)
        let currentUser2 = CurrentUser(name: "User2", ip: 1921684, isConnected: false)
        let runningProcess1 = RunningProcess(name: "Process1", ip: 1921685, isConnected: true)
        let runningProcess2 = RunningProcess(name: "Process2", ip: 1921686, isConnected: false)
        
        return [
            ServerState(dateTime: .random, upTime: 3600, memoryUsage: 512, networkConnections: [networkConnection1], currentUsers: [currentUser1], runningProcesses: [runningProcess1], averageTurnAroundTime: Double.random(in: 0...0.2)),
            ServerState(dateTime: .random, upTime: 7200, memoryUsage: 1024, networkConnections: [networkConnection1, networkConnection2], currentUsers: [currentUser1, currentUser2], runningProcesses: [runningProcess1, runningProcess2], averageTurnAroundTime: Double.random(in: 0...0.2)),
            ServerState(dateTime: .random, upTime: 10800, memoryUsage: 2048, networkConnections: [networkConnection2], currentUsers: [currentUser2], runningProcesses: [runningProcess2], averageTurnAroundTime: Double.random(in: 0...0.2)),
            ServerState(dateTime: .random, upTime: 10800, memoryUsage: 2048, networkConnections: [networkConnection2], currentUsers: [currentUser2], runningProcesses: [runningProcess2], averageTurnAroundTime: Double.random(in: 0...0.2)),
            ServerState(dateTime: .random, upTime: 10800, memoryUsage: 2048, networkConnections: [networkConnection2], currentUsers: [currentUser2], runningProcesses: [runningProcess2], averageTurnAroundTime: Double.random(in: 0...0.2)),
            ServerState(dateTime: .random, upTime: 10800, memoryUsage: 2048, networkConnections: [networkConnection2], currentUsers: [currentUser2], runningProcesses: [runningProcess2], averageTurnAroundTime: Double.random(in: 0...0.2))
        ]
    }
}

struct NetworkConnection: Codable, Hashable {
    let proto: String
    let receiveQueue: String
    let sendQueue: String
    let localAddress: String
    let foreignAddress: String
    let state: String?
    
    static let empty = [NetworkConnection(proto: "", receiveQueue: "", sendQueue: "", localAddress: "", foreignAddress: "", state: "")]
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
    
   mutating func next() {
        switch self {
        case .dateTime:
            self = .upTime
        case .upTime:
            self = .memoryUsage
        case .memoryUsage:
            self = .networkConnections
        case .networkConnections:
            self = .currentUsers
        case .currentUsers:
            self = .runningProcesses
        case .runningProcesses:
            self = .dateTime
        }
    }
}
enum TurnAroundTime: String, CaseIterable, Codable {
    case elapsed = "Elapsed Time"
    case total = "Total"
    case average = "Average"
    
    mutating func next() {
        switch self {
        case .elapsed:
            self = .total
        case .total:
            self = .average
        case .average:
            self = .elapsed
        }
    }
}
