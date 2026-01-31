//
//  LabelBarView.swift
//  EatNeat
//
//  Created by Oscar Horner on 31/01/2026.
//
// Horizontal bar of labels that can be selected / deselected, owned by the parent.

import SwiftUI

struct LabelBarView: View {

    /// All available labels the user can choose from
    let availableLabels: [ItemLabel]

    /// Currently selected labels
    @Binding var selectedLabels: Set<ItemLabel>

    /// Whether multiple labels can be selected
    let allowsMultipleSelection: Bool

    init(
        availableLabels: [ItemLabel],
        selectedLabels: Binding<Set<ItemLabel>>,
        allowsMultipleSelection: Bool = true
    ) {
        self.availableLabels = availableLabels
        self._selectedLabels = selectedLabels
        self.allowsMultipleSelection = allowsMultipleSelection
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {

                ForEach(availableLabels) { label in
                    CapsuleView(
                        text: label.name,
                        color: label.color,
                        heavy: isSelected(label)
                    ) {
                        toggle(label)
                    }
                }

                // Clear / none action
                if !selectedLabels.isEmpty {
                    CapsuleView(
                        text: "Clear",
                        color: .gray,
                        heavy: true
                    ) {
                        selectedLabels.removeAll()
                        UIImpactFeedbackGenerator(style: .light)
                            .impactOccurred()
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }

    // MARK: - Selection logic

    private func toggle(_ label: ItemLabel) {
        if selectedLabels.contains(label) {
            selectedLabels.remove(label)
        } else {
            if !allowsMultipleSelection {
                selectedLabels.removeAll()
            }
            selectedLabels.insert(label)
        }

        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    private func isSelected(_ label: ItemLabel) -> Bool {
        selectedLabels.contains(label)
    }
}
