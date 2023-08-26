//
//  ServerHistoryView.swift
//  IterativeSocketClient
//
//  Created by Andreas Ink on 8/26/23.
//

import SwiftUI

struct ServerHistoryView: View {
    @Binding var selectedState: ServerState?
    var history: [ServerState]
    var body: some View {
        List(history, id: \.dateTime, selection: $selectedState) { state in
            NavigationLink(state.dateTime.formatted(), value: state)
        }
    }
}
