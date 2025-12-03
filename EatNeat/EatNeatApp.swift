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
    @StateObject private var pantryViewModel = PantryViewModel()
    @StateObject private var donationViewModel: DonationViewModel
    @StateObject private var agentViewModel = AgentViewModel()
    @StateObject var appBridge = AppBridge() // app bridge to expose functionality to MCP server
    
    init() {
        let pantryVM = PantryViewModel()
        _pantryViewModel = StateObject(wrappedValue: pantryVM)
        _donationViewModel = StateObject(
            wrappedValue: DonationViewModel(
                locationManager: LocationManager(),
                pantryViewModel: pantryVM
            )
        )
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(pantryViewModel)
                .environmentObject(donationViewModel)
                .environmentObject(appBridge)
                .environmentObject(agentViewModel)
        }
    }
}
