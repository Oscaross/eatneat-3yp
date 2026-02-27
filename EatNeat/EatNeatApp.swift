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
    @StateObject private var agentModel = AgentModel()
    @StateObject private var settingsModel = SettingsModel()
    @StateObject private var bannerManager = BannerManager()
    
    init() {
        let pantryVM = PantryViewModel()
        _pantryViewModel = StateObject(wrappedValue: pantryVM)
        _donationViewModel = StateObject(
            wrappedValue: DonationViewModel(
            )
        )
    }

    var body: some Scene {
        WindowGroup {
            AppBackgroundView {
                ContentView()
                    .environmentObject(pantryViewModel)
                    .environmentObject(donationViewModel)
                    .environmentObject(agentModel)
                    .environmentObject(settingsModel)
                    .environmentObject(bannerManager)
            }
        }
    }
}
