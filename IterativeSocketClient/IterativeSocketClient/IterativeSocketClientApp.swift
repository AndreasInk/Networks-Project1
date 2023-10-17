//
//  IterativeSocketClientApp.swift
//  IterativeSocketClient
//
//  Created by Andreas Ink on 8/26/23.
//

import SwiftUI

@main
struct IterativeSocketClientApp: App {
    @StateObject var networkManager = NetworkManager()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(networkManager)
        }
        WindowGroup("Analytics", id: .statsWindow) {
            AnalyticsView()
                .environmentObject(networkManager)
        }
        .windowStyle(.hiddenTitleBar)
    }
}
