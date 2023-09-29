//
//  ServerStateDetailView.swift
//  IterativeSocketClient
//
//  Created by Andreas Ink on 8/26/23.
//

import SwiftUI

struct ServerStateDetailView: View {
    var state: ServerState
    var body: some View {
        List {
            Section("General Info") {
                VStack(alignment: .leading) {
                    Text(state.dateTime, format: .dateTime)
                    Text(state.memoryUsage, format: .number)
                }
            }
            Section("Connections") {
                VStack(alignment: .leading) {
                    ForEach(state.networkConnections, id: \.name) { connection in
                        Text(connection.ip, format: .number)
                    }
                    ForEach(state.currentUsers, id: \.name) { connection in
                        Text(connection.name)
                    }
                    ForEach(state.runningProcesses, id: \.name) { connection in
                        Text(connection.name)
                    }
                }
            }
        }
    }
}
