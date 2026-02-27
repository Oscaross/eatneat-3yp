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
    @AppStorage("compactPantryView") private var compactPantryView = false

    var body: some View {
        NavigationStack {
            List {
                // MARK: Preferences
                preferences

                // MARK: Label management
                Section {
                    LabelBarView(pantryVM: pantryVM)
                } header: {
                    Text("Labels (\(pantryVM.getUserLabels().count))")
                } footer: {
                    Text("Labels are custom tags that you can apply to your products to help filter, organise and keep track of them.")
                }
            }
            .sheet(isPresented: $showAddLabelSheet) {
                AddLabelSheet()
            }
        }
    }

    var preferences: some View {
        Section {
            preferenceRow(
                description: "Haptic Feedback",
                interactor: CapsuleToggleView(
                    value: $enableHaptics,
                    trueLabel: .text("On"),
                    falseLabel: .text("Off"),
                    color: .gray,
                    shouldChangeAppearanceOnToggle: false
                )
            )

            preferenceRow(
                description: "Donation Tips",
                interactor: CapsuleToggleView(
                    value: $autoDonateSuggestions,
                    trueLabel: .text("On"),
                    falseLabel: .text("Off"),
                    color: .gray,
                    shouldChangeAppearanceOnToggle: false
                )
            )

            preferenceRow(
                description: "Pantry View",
                interactor: CapsuleToggleView(
                    value: $compactPantryView,
                    trueLabel: .text("Compact"),
                    falseLabel: .text("Grid"),
                    color: .gray,
                    shouldChangeAppearanceOnToggle: false
                )
            )
        } header: {
            Text("Settings")
        } footer: {
            Text("Personalise the app to your own needs.")
        }
    }

    private func preferenceRow<Interactor: View>(
        description: String,
        interactor: Interactor
    ) -> some View {
        HStack {
            Text(description)
            Spacer()
            interactor
        }
    }
}
