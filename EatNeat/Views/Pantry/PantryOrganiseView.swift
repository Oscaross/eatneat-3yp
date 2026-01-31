//
//  PantryOrganiseView.swift
//  EatNeat
//
//  Created by Oscar Horner on 30/01/2026.
//
// Sheet view to allow users to organise their pantry, in a "swipe" type view filtering out unwanted or used up items quickly.

import SwiftUI

struct PantryOrganiseView: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var pantryVM: PantryViewModel

    // Stack of items to organise
    @State private var items: [PantryItem]

    // Card drag state
    @State private var dragOffset: CGSize = .zero
    @State private var cardRotation: Double = 0

    // TODO: Make this a stack of references to older items that have been modified
    @State private var lastRemovedItem: PantryItem?

    // Tunables
    private let swipeThresholdX: CGFloat = 120
    private let swipeThresholdY: CGFloat = 120
    private let maxRotationDegrees: Double = 14

    init(items: [PantryItem], pantryVM: PantryViewModel) {
        _items = State(initialValue: items)
        self.pantryVM = pantryVM
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                ZStack {
                    if let currentItemBinding = topItemBinding {
                        PantryItemView(
                            item: currentItemBinding,
                            availableLabels: pantryVM.userLabels,
                            mode: .edit
                        )
                        .padding(16)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .strokeBorder(.primary.opacity(0.12), lineWidth: 1)
                        )
                        
                    } else {
                        emptyState
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 420)
                .padding(.horizontal, 16)
                .offset(dragOffset)
                .rotationEffect(.degrees(cardRotation), anchor: .bottom)
                .gesture(dragGesture)
                .animation(.spring(response: 0.28, dampingFraction: 0.85), value: dragOffset)
                .animation(.spring(response: 0.28, dampingFraction: 0.85), value: cardRotation)

                // Bottom controls
                bottomControls
            }
            .navigationTitle("Manage Pantry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Undo") { undoLastAction() }
                        .disabled(lastRemovedItem == nil)
                }
            }
        }
    }
}

private extension PantryOrganiseView {

    /// Binding to the top item in the stack
    var topItemBinding: Binding<PantryItem>? {
        guard !items.isEmpty else { return nil }
        return Binding(
            get: { items[items.count - 1] },
            set: { items[items.count - 1] = $0 }
        )
    }

    var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                dragOffset = value.translation
                let normalizedX = max(-1, min(1, value.translation.width / 220))
                cardRotation = Double(normalizedX) * maxRotationDegrees
            }
            .onEnded { value in
                handleDragEnded(value.translation)
            }
    }

    var bottomControls: some View {
        HStack {
            Button { deleteCurrent(animated: true) } label: {
                controlIcon(systemName: "trash", color: .red)
            }

            Spacer()

            Button { resetCard() } label: {
                controlIcon(systemName: "arrow.clockwise", color: .gray)
            }

            Spacer()

            Button { approveCurrent(animated: true) } label: {
                controlIcon(systemName: "hand.thumbsup.fill", color: .green)
            }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 16)
    }
}

private extension PantryOrganiseView {

    func handleDragEnded(_ translation: CGSize) {
        if translation.height > swipeThresholdY {
            popCurrent(animated: true)
            return
        }

        if translation.width > swipeThresholdX {
            approveCurrent(animated: true)
            return
        }

        if translation.width < -swipeThresholdX {
            deleteCurrent(animated: true)
            return
        }

        resetCard()
    }

    func popCurrent(animated: Bool = false) {
        guard let item = items.last else { return }
        lastRemovedItem = item

        if animated {
            animateCardOffscreen(direction: .down)
        }

        items.removeLast()
        resetCard()
    }

    func deleteCurrent(animated: Bool = false) {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        popCurrent(animated: animated)
    }

    func approveCurrent(animated: Bool = false) {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        popCurrent(animated: animated)
    }

    func undoLastAction() {
        guard let item = lastRemovedItem else { return }
        items.append(item)
        lastRemovedItem = nil
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    func resetCard() {
        withAnimation(.spring(response: 0.28, dampingFraction: 0.85)) {
            dragOffset = .zero
            cardRotation = 0
        }
    }
}

private extension PantryOrganiseView {

    enum OffscreenDirection { case left, right, down }

    func animateCardOffscreen(direction: OffscreenDirection) {
        let screenW = UIScreen.main.bounds.width

        withAnimation(.spring(response: 0.25, dampingFraction: 0.85)) {
            switch direction {
            case .left:
                dragOffset = CGSize(width: -screenW, height: 40)
                cardRotation = -maxRotationDegrees
            case .right:
                dragOffset = CGSize(width: screenW, height: 40)
                cardRotation = maxRotationDegrees
            case .down:
                dragOffset = CGSize(width: 0, height: 700)
                cardRotation = 0
            }
        }
    }

    func controlIcon(systemName: String, color: Color) -> some View {
        Image(systemName: systemName)
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(color)
            .frame(width: 46, height: 46)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(color.opacity(0.12))
            )
    }

    var emptyState: some View {
        Text("All items organised")
            .foregroundStyle(.secondary)
            .font(.headline)
    }
}
