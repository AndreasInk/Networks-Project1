//
//  AnalyticsView.swift
//  IterativeSocketClient
//
//  Created by Andreas Ink on 8/28/23.
//

import SwiftUI
import Charts

struct AnalyticsView: View {
    var history: [ServerState]
    @State var selectedCommand = ServerCommand.dateTime
    var body: some View {
        VStack(alignment: .leading) {
            Text(selectedCommand.rawValue)
                .contentTransition(.numericText())
                .font(.largeTitle.bold())
                .padding()
                .onTapGesture {
                    withAnimation(.spring()) {
                        selectedCommand.next()
                    }
                }
            
            Chart {
                switch selectedCommand {
                case .dateTime:
                    ForEach(history, id: \.dateTime) { state in
                        BarMark(x: .value("", state.dateTime), y: .value("", state.upTime))
                    }
                case .upTime:
                    ForEach(history, id: \.dateTime) { state in
                        BarMark(x: .value("", state.dateTime), y: .value("", state.upTime))
                    }
                case .memoryUsage:
                    ForEach(history, id: \.dateTime) { state in
                        BarMark(x: .value("", state.dateTime), y: .value("", state.memoryUsage))
                    }
                case .networkConnections:
                    ForEach(history, id: \.dateTime) { state in
                        ForEach(state.networkConnections, id: \.name) { connection in
                            BarMark(x: .value("", state.dateTime), y: .value("", connection.ip))
                        }
                    }
                case .currentUsers:
                    ForEach(history, id: \.dateTime) { state in
                        ForEach(state.currentUsers, id: \.name) { connections in
                            BarMark(x: .value("", state.dateTime), y: .value("", connections.ip))
                        }
                    }
                case .runningProcesses:
                    ForEach(history, id: \.dateTime) { state in
                        ForEach(state.currentUsers, id: \.name) { connections in
                            BarMark(x: .value("", state.dateTime), y: .value("", connections.ip))
                        }
                    }
                }
                
            }
            .chartXAxis {
                AxisMarks { value in
                    AxisGridLine()
                    AxisTick()
                    if value.index != value.count -  1 {
                        AxisValueLabel()
                    }
                }
            }
            .chartYAxis {
                AxisMarks { value in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel()
                }
            }
        }
        .padding()
    }
}
