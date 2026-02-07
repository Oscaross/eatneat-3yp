//
//  AfterScanView.swift
//  EatNeat
//
//  Created by Oscar Horner on 18/12/2025.
//
// Shown on successful scan to show the user which items are scanned and their details.

// TODO: We want to have a confidence value from the LLM and OCR, and highlight low confidence scans for the user first.
// TODO: Allow the user to delete items from the pre-scanned list before adding the whole list to the pantry

import SwiftUI
import UIKit

struct AfterScanView: View {
    @ObservedObject var pantryViewModel: PantryViewModel
    @State private var scannedItems: [PantryItem]
    @State private var selection = 0
    let onDone: () -> Void

    @Environment(\.dismiss) private var dismiss

    @State private var isCompleting = false
    @State private var showSuccess = false

    init(scanned: [PantryItem], vm: PantryViewModel, onDone: @escaping () -> Void) {
        _scannedItems = State(initialValue: scanned)
        self.pantryViewModel = vm
        self.onDone = onDone
    }

    var body: some View {
        NavigationStack {
            ZStack {
                TabView(selection: $selection) {
                    ForEach(scannedItems.indices, id: \.self) { i in
                        Form {
                            PantryItemFormView(item: $scannedItems[i], availableLabels: pantryViewModel.getUserLabels())
                        }
                        .tag(i)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .automatic))
                .navigationTitle("Review Items (\(selection + 1)/\(scannedItems.count))")
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Add All") { addAllAndDismiss() }
                            .disabled(isCompleting || scannedItems.isEmpty)
                    }

                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            onDone()
                        }
                            .disabled(isCompleting)
                    }
                }
                .disabled(isCompleting)

                if showSuccess {
                    successOverlay
                        .transition(.opacity.combined(with: .scale(scale: 0.95)))
                }
            }
        }
        .onAppear {
            let gen = UINotificationFeedbackGenerator()
            gen.prepare()
            gen.notificationOccurred(.success)
        }
    }

    private var successOverlay: some View {
        VStack(spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 56, weight: .semibold))
            Text("Added to pantry")
                .font(.headline)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    @MainActor
    private func addAllAndDismiss() {
        guard !isCompleting else { return }
        isCompleting = true

        // Add items
        scannedItems.forEach { pantryViewModel.addItem(item: $0) }

        // Haptics + animation
        playAddAllHaptics()
        withAnimation(.spring(response: 0.25, dampingFraction: 0.85)) {
            showSuccess = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            withAnimation(.easeOut(duration: 0.25)) {
                showSuccess = false
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            onDone()
        }
    }

    private func playAddAllHaptics() {
        // MARK: Haptic feedback for a few light taps and success indicator
        let light = UIImpactFeedbackGenerator(style: .light)
        let soft = UIImpactFeedbackGenerator(style: .soft)
        let success = UINotificationFeedbackGenerator()

        light.prepare()
        soft.prepare()
        success.prepare()

        // A quick rhythmic sequence
        light.impactOccurred(intensity: 0.6)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.07) {
            soft.impactOccurred(intensity: 0.7)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.14) {
            light.impactOccurred(intensity: 0.8)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.22) {
            success.notificationOccurred(.success)
        }
    }
}
