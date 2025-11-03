//
//  EatNeatApp.swift
//  EatNeat
//
//  Created by Oscar Horner on 30/10/2025.
//

import SwiftUI
import SwiftMCP
import MCP

@main
struct EatNeatApp: App {
    @State private var mcpServerManager = MCPServerManager()
    @StateObject private var locationManager = LocationManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                // register location manager as global environment variable
                .environmentObject(locationManager)
                // Run the MCP server automatically when the app launches
                .task {
                    await startMCPServer()
                }
        }
    }

    private func startMCPServer() async {
        do {
            try await mcpServerManager.startServer()
        } catch {
            print("Failed to start EatNeat MCP Server: \(error)")
        }
    }
}
