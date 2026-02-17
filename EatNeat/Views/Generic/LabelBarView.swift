//
//  LabelBarView.swift
//  EatNeat
//
//  Created by Oscar Horner on 31/01/2026.
//
// Horizontal bar of labels that can be selected / deselected, owned by the parent.

import SwiftUI

struct LabelBarView: View {
    
    let availableLabels: [ItemLabel]
    private let interaction: LabelBarInteraction
    private let onAddLabel: (() -> Void)?

    @Binding private var selectedLabels: Set<ItemLabel>

    /// Interactable constructor
    init(
        availableLabels: [ItemLabel],
        selectedLabels: Binding<Set<ItemLabel>>,
        allowsMultipleSelection: Bool = true,
        onAddLabel: (() -> Void)? = nil
    ) {
        self.availableLabels = availableLabels
        self._selectedLabels = selectedLabels
        self.interaction = .selectable(allowsMultiple: allowsMultipleSelection)
        self.onAddLabel = onAddLabel
    }
    
    /// View only constructor - no selected labels
    init(
        availableLabels: [ItemLabel],
        onAddLabel: (() -> Void)? = nil
    ) {
        self.availableLabels = availableLabels
        self._selectedLabels = .constant([])
        self.interaction = .viewOnly
        self.onAddLabel = onAddLabel
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {

                ForEach(availableLabels) { label in
                    CapsuleView(
                        content: .text(label.name),
                        color: label.color,
                        heavy: isSelected(label)
                    ) {
                        handleTap(label)
                    }
                    .opacity(isSelectable ? 1.0 : 0.6)
                }

                AddButtonView(
                    color: .gray,
                    action: {}
                )
            }
            .padding(.vertical, 4)
        }
    }


    // MARK: - Selection logic

    private func isSelected(_ label: ItemLabel) -> Bool {
        selectedLabels.contains(label)
    }
    
    private var isSelectable: Bool {
        if case .selectable = interaction { return true }
        return false
    }

    private func handleTap(_ label: ItemLabel) {
        guard case .selectable(let allowsMultiple) = interaction else {
            return
        }

        if selectedLabels.contains(label) {
            selectedLabels.remove(label)
        } else {
            if !allowsMultiple {
                selectedLabels.removeAll()
            }
            selectedLabels.insert(label)
        }

        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
}

enum LabelBarInteraction {
    case selectable(allowsMultiple: Bool)
    case viewOnly
}
