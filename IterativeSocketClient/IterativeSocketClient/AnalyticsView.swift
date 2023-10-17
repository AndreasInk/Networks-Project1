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
    var body: some View {
        let history = networkManager.serverStateHistory
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
            }
            
            Chart {
                switch selectedTime {
                case .elapsed:
                    ForEach(history, id: \.dateTime) { state in
                        LineMark(x: .value("", state.dateTime), y: .value("", state.turnAroundTime))
                    }
                case .total:
                    ForEach(history, id: \.dateTime) { state in
                        LineMark(x: .value("", state.dateTime), y: .value("", state.turnAroundTime))
                    }
                case .average:
                    ForEach(history, id: \.dateTime) { state in
                        LineMark(x: .value("", state.dateTime), y: .value("", state.turnAroundTime))
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
