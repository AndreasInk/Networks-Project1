//
//  NetworkManager.swift
//  IterativeSocketClient
//
//  Created by Andreas Ink on 8/26/23.
//

import SwiftUI

class NetworkManager: ObservableObject {
    
    @MainActor @Published var serverStateHistory: [Date: ServerState] = [:]
    @MainActor @Published var serverStateHistorySecond: [Date: ServerState] = [:]
    @MainActor @Published var serverStateHistoryMinute: [Date: ServerState] = [:]
    @Published var url: URL = URL(string: "http://127.0.0.1:3216")!//URL(string: "http://139.62.210.155:3215")!
    
    let decoder = JSONDecoder()
    
   func sendRequests(numberOfRequests: Int, command: ServerCommand) {
        let date = Date()
        for _ in 0...numberOfRequests {
            Task {
                let session = URLSession(configuration: .default)
                session.configuration.timeoutIntervalForRequest = 25
                let data = try await session.data(from: url.appending(path: command.rawValue))
                print(String(data: data.0, encoding: .utf8))
                decoder.dateDecodingStrategy = .secondsSince1970
                if await serverStateHistory[date] == nil {
                    Task { @MainActor in
                        serverStateHistory[date] = .empty
                    }
                }
                Task { @MainActor in
                    var currentSeverState = ServerState.empty
                    switch command {
                    case .dateTime:
                        currentSeverState.dateTime = try decoder.decode(DateTime.self, from: data.0).dateTime
                        currentSeverState.command = .dateTime
                    case .upTime:
                        currentSeverState.upTime = try decoder.decode(UpTime.self, from: data.0).upTime
                        currentSeverState.command = .upTime
                    case .memoryUsage:
                        currentSeverState.memoryUsage = Int(try decoder.decode(MemoryUsage.self, from: data.0).memoryUsage)
                        currentSeverState.command = .memoryUsage
                    case .networkConnections:
                        currentSeverState.networkConnections = try decoder.decode([NetworkConnection].self, from: data.0)
                        currentSeverState.command = .networkConnections
                    case .currentUsers:
                        currentSeverState.currentUsers = try decoder.decode([CurrentUser].self, from: data.0)
                        currentSeverState.command = .currentUsers
                    case .runningProcesses:
                        currentSeverState.runningProcesses = try decoder.decode([RunningProcess].self, from: data.0)
                        currentSeverState.command = .runningProcesses
                    }
                    let turnAroundTime = date.distance(to: Date())
                    currentSeverState.turnAroundTime = turnAroundTime
                    currentSeverState.totalTurnAroundTime += turnAroundTime
                    currentSeverState.turnAroundCount += 1
                    
                    serverStateHistory[normalizeDate(to: [.nanosecond], with: date)] = currentSeverState
                    
                    var secondSeverState = ServerState.empty
                    
                    secondSeverState.turnAroundTime = turnAroundTime
                    secondSeverState.totalTurnAroundTime += turnAroundTime
                    secondSeverState.turnAroundCount += 1
                    
                    serverStateHistorySecond[normalizeDate(to: [.second], with: date)] = secondSeverState
                    
                    var minuteSeverState = ServerState.empty
                    
                    minuteSeverState.turnAroundTime = turnAroundTime
                    minuteSeverState.totalTurnAroundTime += turnAroundTime
                    minuteSeverState.turnAroundCount += 1
                    
                    serverStateHistoryMinute[normalizeDate(to: [.minute], with: date)] = minuteSeverState
                    
                }
            }
        }
   }
    func normalizeDate(to unit: Set<Calendar.Component>, with date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents(unit, from: date)
        return calendar.date(from: components) ?? Date()
    }
}
