//
//  ContentView.swift
//  IterativeSocketClient
//
//  Created by Andreas Ink on 8/26/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var networkManager = NetworkManager()
    @State var selectedState: ServerState?
    var body: some View {
        
        NavigationSplitView(sidebar: {
            ServerHistoryView(selectedState: $selectedState, history: networkManager.severStateHistory)
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            selectedState = .empty
                            if let selectedState {
                                networkManager.currentSeverState = selectedState
                                networkManager.severStateHistory.append(selectedState)
                            }
                            
                        } label: {
                            Image(systemName: "plus")
                        }

                    }
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
