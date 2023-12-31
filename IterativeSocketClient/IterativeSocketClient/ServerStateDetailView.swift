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
        VStack(alignment: .leading, spacing: 20) {
            Section("General Info") {
                VStack(alignment: .leading) {
                    Text(Date(timeIntervalSince1970: state.dateTime), format: .dateTime)
                    Text(state.memoryUsage, format: .number)
                    Text(state.turnAroundTime, format: .number)
                }
            }
            Section("Connections") {
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(state.networkConnections, id: \.localAddress) { connection in
                            Text(connection.foreignAddress)
                        }
                        ForEach(state.currentUsers, id: \.name) { connection in
                            Text(connection.name)
                        }
                        ForEach(state.runningProcesses, id: \.user) { connection in
                            Text(connection.user)
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding()
    }
}
