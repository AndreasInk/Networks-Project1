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
        Text(state.dateTime.formatted())
    }
}
