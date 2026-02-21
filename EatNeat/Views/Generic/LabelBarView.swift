//
//  LabelBarView.swift
//  EatNeat
//
//  Created by Oscar Horner on 31/01/2026.
//
// Horizontal bar of labels that can be selected / deselected, owned by the parent.

import SwiftUI

struct LabelBarView: View {
    
    @ObservedObject var pantryVM: PantryViewModel
    private let interaction: LabelBarInteraction
    private let onAddLabel: (() -> Void)?

    @Binding private var selectedLabels: Set<ItemLabel>
    
    @State private var showAddLabelSheet: Bool = false
    
    @State private var isDeleting: Bool = false // make labels wiggle + allow taps to delete them

    /// Interactable constructor
    init(
        pantryVM: PantryViewModel,
        selectedLabels: Binding<Set<ItemLabel>>,
        allowsMultipleSelection: Bool = true,
        onAddLabel: (() -> Void)? = nil
    ) {
        self.pantryVM = pantryVM
        self._selectedLabels = selectedLabels
        self.interaction = .selectable(allowsMultiple: allowsMultipleSelection)
        self.onAddLabel = onAddLabel
    }
    
    /// View only constructor - no selected labels
    init(
        pantryVM: PantryViewModel,
        onAddLabel: (() -> Void)? = nil
    ) {
        self.pantryVM = pantryVM
        self._selectedLabels = .constant([])
        self.interaction = .viewOnly
        self.onAddLabel = onAddLabel
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 9) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    
                    if isSelectable {
                        CapsuleMenu<ItemLabel>(
                            title: "Label",
                            options: pantryVM.getUserLabels().filter { !selectedLabels.contains($0) },
                            display: { $0.name },
                            onConfirm: { label in
                                selectedLabels.insert(label)
                            },
                            color: .gray,
                            label: {
                                CapsuleView(
                                    content: .icon(systemName: "tag"),
                                    color: .gray,
                                    heavy: false,
                                    action: {}
                                )
                            }
                        )
                    }
                    
                    // Edit button in viewOnly mode
                    if !isSelectable {
                        CapsuleView(
                            content: .icon(systemName: isDeleting ? "checkmark" : "pencil"),
                            color: isDeleting ? AppStyle.primary : .gray,
                            heavy: false
                        ) {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            withAnimation(.easeInOut(duration: 0.2)) {
                                isDeleting.toggle()
                            }
                        }
                    }
                    
                    AddButtonView(color: .gray) {
                        showAddLabelSheet = true
                    }
                }
                .padding(.vertical, 4)
            }
            
            // MARK: Bottom Row – Labels
            if isSelectable && !selectedLabels.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(Array(selectedLabels), id: \.self) { label in
                            CapsuleView(
                                content: .text(label.name),
                                color: label.color,
                                heavy: false
                            ) {
                                handleTap(label)
                            }
                        }
                    }
                    .padding(.vertical, 2)
                }
            }
            
            if !isSelectable {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(Array(pantryVM.getUserLabels()), id: \.self) { label in
                            CapsuleView(
                                content: .text(label.name),
                                color: label.color,
                                heavy: false
                            ) {
                                if isDeleting {
                                    pantryVM.removeLabel(label: label)
                                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                                }
                            }
                            .modifier(
                                WiggleEffect(animatableData: isDeleting ? 1 : 0)
                            )
                            .animation(
                                isDeleting
                                ? .linear(duration: 0.3).repeatForever(autoreverses: true)
                                : .default,
                                value: isDeleting
                            )
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showAddLabelSheet) {
            AddLabelSheetView(
                onAdd: { name, color in
                    pantryVM.addLabel(name: name, color: color)
                },
                onDismiss: {
                    showAddLabelSheet = false
                }
            )
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

struct WiggleEffect: GeometryEffect {
    var angle: Double = 2 // rotation max in degrees
    var shakesPerUnit: Double = 2 // speed
    var animatableData: Double

    func effectValue(size: CGSize) -> ProjectionTransform {
        let rotation = angle * sin(animatableData * .pi * shakesPerUnit)
        return ProjectionTransform(
            CGAffineTransform(rotationAngle: CGFloat(rotation * .pi / 180))
        )
    }
}
