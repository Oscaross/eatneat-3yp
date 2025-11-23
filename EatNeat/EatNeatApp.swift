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
    @StateObject private var pantryViewModel = PantryViewModel() // pantry view model to manage pantry data
    @StateObject private var donationViewModel = DonationViewModel(locationManager: LocationManager()) // donation view model to manage foodbanks and their need > item mappings
    @StateObject var appBridge = AppBridge() // app bridge to expose functionality to MCP server

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(pantryViewModel)
                .environmentObject(donationViewModel)
                .environmentObject(appBridge)
        }
    }
}
