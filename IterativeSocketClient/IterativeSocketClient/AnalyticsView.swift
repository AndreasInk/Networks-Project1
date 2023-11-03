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
                    ForEach(Array(networkManager.serverStateHistory.values), id: \.requestDate) { state in
                        switch selectedCommand {
                            case 
                        }
                        BarMark(x: .value("", state.requestDate), y: .value("", state.turnAroundTime))
                    }
                case .total:
                    ForEach(Array(networkManager.serverStateHistory.values), id: \.requestDate) { state in
                        LineMark(x: .value("", state.requestDate), y: .value("", state.totalTurnAroundTime))
                    }
                case .average:
                    ForEach(Array(networkManager.serverStateHistory.values), id: \.requestDate) { state in
                        LineMark(x: .value("", state.requestDate), y: .value("", state.averageTurnAroundTime))
                    }
                }
                
            }
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

