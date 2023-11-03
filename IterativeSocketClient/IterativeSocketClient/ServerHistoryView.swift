//
//  ServerHistoryView.swift
//  IterativeSocketClient
//
//  Created by Andreas Ink on 8/26/23.
//

import SwiftUI

struct ServerHistoryView: View {
    @Binding var selectedState: ServerState?
    var history: [Date: ServerState]
    var body: some View {
        List(Array(history.values), id: \.id, selection: $selectedState) { state in
            NavigationLink(state.requestDate.formatted(), value: state)
        }
    }
}
