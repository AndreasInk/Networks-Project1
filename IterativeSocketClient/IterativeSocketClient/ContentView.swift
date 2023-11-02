//
//  ContentView.swift
//  IterativeSocketClient
//
//  Created by Andreas Ink on 8/26/23.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var networkManager: NetworkManager
    @State var selectedState: ServerState?
    @Environment(\.openWindow) var openWindow
    @State var numberOfRequests = 2
    @State var selectedCommand = ServerCommand.dateTime
    
    var body: some View {
        
        NavigationSplitView(sidebar: {
            VStack {
                ServerHistoryView(selectedState: $selectedState, history: networkManager.serverStateHistory)
                    .toolbar {
                        ToolbarItem(placement: .primaryAction) {
                            Button {
                                networkManager.sendRequest()
                            } label: {
                                Image(systemName: "plus")
                            }
                        }
                        ToolbarItem {
                            Button {
                                openWindow(id: .statsWindow)
                            } label: {
                                Image(systemName: "chart.bar")
                            }
                        }
                    }
                VStack {
                    Button {
                        withAnimation(.spring()) {
                            selectedCommand.next()
                        }
                    } label: {
                        Text(selectedCommand.rawValue)
                            .contentTransition(.numericText())
                    }
                    
                    TextField(value: $numberOfRequests, format: .number, label: {
                        
                    })
                        .onSubmit {
                            networkManager.sendRequests(numberOfRequests: numberOfRequests, command: selectedCommand)
                        }
                    Button {
                        networkManager.sendRequests(numberOfRequests: numberOfRequests, command: selectedCommand)
                    } label: {
                        Text("Send")
    
                    }

                }
                .padding()
            }
        }, detail: {
            if let selectedState {
                ServerStateDetailView(state: selectedState)
            }
        })
       
    }
}

#Preview {
    ContentView()
}
