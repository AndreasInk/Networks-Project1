//
//  IterativeSocketClientApp.swift
//  IterativeSocketClient
//
//  Created by Andreas Ink on 8/26/23.
//

import SwiftUI

@main
struct IterativeSocketClientApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        
        }
        WindowGroup("Analytics", id: .statsWindow) {
            AnalyticsView(history: ServerState.mockData)
        }
        .windowStyle(.hiddenTitleBar)
    }
}
