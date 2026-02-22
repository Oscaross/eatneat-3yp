//
//  AppSettings.swift
//  EatNeat
//
//  Created by Oscar Horner on 22/02/2026.
//
// A global observable object that serves all custom settings that the user has picked for their pantry in the Customise view.

import SwiftUI

@MainActor
final class SettingsModel: ObservableObject {

    @AppStorage("enableHaptics") var enableHaptics: Bool = true
    @AppStorage("autoDonateSuggestions") var autoDonateSuggestions: Bool = true
    @AppStorage("compactPantryView") var compactPantryView: Bool = false
}
