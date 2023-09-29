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
        VStack {
            Chart(history, id: \.dateTime) { state in
                LineMark(x: .value("", state.dateTime), y: .value("", state.memoryUsage))
                    .annotation {
                        if state.lastCommandSent == selectedCommand {
                            ZStack {
                                Circle()
                                    .foregroundStyle(.thinMaterial)
                                Text(selectedCommand.rawValue)
                            }
                        }
                    }
            }
        }
    }
}
