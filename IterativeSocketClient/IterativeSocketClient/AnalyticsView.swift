//
//  AnalyticsView.swift
//  IterativeSocketClient
//
//  Created by Andreas Ink on 8/28/23.
//

import SwiftUI
import Charts

struct AnalyticsView: View {
    @EnvironmentObject var networkManager: NetworkManager
    @State var selectedCommand = ServerCommand.dateTime
    @State var selectedTime = TurnAroundTime.elapsed
    
    @State var unit: Calendar.Component = .nanosecond
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(selectedCommand.rawValue)
                    .contentTransition(.numericText())
                    .font(.largeTitle.bold())
                    .padding()
                    .onTapGesture {
                        withAnimation(.spring()) {
                            selectedCommand.next()
                        }
                    }
                Text(selectedTime.rawValue)
                    .contentTransition(.numericText())
                    .font(.largeTitle.bold())
                    .padding()
                    .onTapGesture {
                        withAnimation(.spring()) {
                            selectedTime.next()
                        }
                    }
                Text(unit == .nanosecond ? "Nanosecond" : unit == .second ? "Second" : "Minute")
                    .contentTransition(.numericText())
                    .font(.largeTitle.bold())
                    .padding()
                    .onTapGesture {
                        withAnimation(.spring()) {
                            if unit == .nanosecond {
                                unit = .second
                            } else if unit == .second {
                                unit = .minute
                            } else {
                                unit = .nanosecond
                            }
                        }
                    }
            }
            
            Chart {
                switch selectedTime {
                case .elapsed:
                    ForEach(Array(networkManager.serverStateHistory.values), id: \.requestDate) { state in
                        if state.command == selectedCommand {
                            BarMark(x: .value("", state.requestDate, unit: unit), y: .value("", state.turnAroundTime))
                        }
                    }
                case .total:
                    ForEach(Array(networkManager.serverStateHistorySecond.values), id: \.requestDate) { state in
                        if state.command == selectedCommand {
                            BarMark(x: .value("", state.requestDate, unit: unit), y: .value("", state.totalTurnAroundTime))
                        }
                    }
                case .average:
                    ForEach(Array(networkManager.serverStateHistorySecond.values), id: \.requestDate) { state in
                        if state.command == selectedCommand {
                            BarMark(x: .value("", state.requestDate, unit: unit), y: .value("", state.averageTurnAroundTime))
                            
                        }
                    }
                }
                
            }
            .contentTransition(.interpolate)
            .chartXAxis {
                AxisMarks(values: .automatic) { index in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel()
                }
            }
            .chartYAxis {
                AxisMarks(values: .automatic) { value in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel()
                }
            }
        }
        .padding()
    }
}

