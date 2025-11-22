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
    @StateObject private var locationManager = LocationManager() // required for give food API to find nearby foodbanks
    @StateObject var appBridge = AppBridge() // app bridge to expose functionality to MCP server

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(locationManager)
                .environmentObject(appBridge)
        }
    }
}
