//
//  CustomiseView.swift
//  EatNeat
//
//  Created by Oscar Horner on 03/12/2025.
//
// Allow the user to customise app settings and tailor features to their own system such as item labels.

import SwiftUI

struct CustomiseView: View {
    @State private var showAddLabelSheet = false
    
    @EnvironmentObject var pantryVM: PantryViewModel
    
    @AppStorage("enableHaptics") private var enableHaptics = true
    @AppStorage("autoDonateSuggestions") private var autoDonateSuggestions = true

    var body: some View {
        NavigationStack {
            List {
                // MARK: Preferences
                preferences
                
                // MARK: Label management
                Section {
                    LabelBarView(availableLabels: pantryVM.userLabels)
                } header: {
                    Text("Labels (\(pantryVM.userLabels.count))")
                } footer: {
                    Text("Labels are custom tags that you can apply to your products to help filter, organise and keep track of them.")
                }
            }
            .navigationTitle("Customise")
            .sheet(isPresented: $showAddLabelSheet) {
                AddLabelSheet()
            }
        }
    }
    
    var preferences: some View {
        return Section {
            Toggle("Haptic Feedback", isOn: $enableHaptics)
            
            Toggle("Donation Suggestions", isOn: $autoDonateSuggestions)
        }
        header: {
            Text("Settings")
        } footer: {
            Text("Personalise the app to your own needs.")
        }
    }
}
