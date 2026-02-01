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
    private let maxDragX: CGFloat = 160
    private let maxDragDown: CGFloat = 180
    private let maxRotationDegrees: Double = 14
    
    @State private var activeAction: SwipeAction?
    @State private var feedbackTriggered = false

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
                        .scrollContentBackground(.hidden)
                        .background(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(Color.gray.opacity(0.06))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .stroke(Color.primary.opacity(0.08), lineWidth: 1)
                        )
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)

                    } else {
                        emptyState
                    }
                }
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
                let rawX = value.translation.width
                let rawY = value.translation.height

                // Clamp horizontal
                let clampedX = max(-maxDragX, min(maxDragX, rawX))

                // Only allow downward drag (no up)
                let clampedY = max(0, min(maxDragDown, rawY))

                dragOffset = CGSize(width: clampedX, height: clampedY)

                // Rotation tied to horizontal %
                let xProgress = clampedX / maxDragX
                cardRotation = Double(xProgress) * maxRotationDegrees

                updateActionFeedback(xProgress: xProgress, yProgress: clampedY / maxDragDown)
            }
            .onEnded { value in
                handleDragEnded(value.translation)
            }
    }
    
    /// Given some normalised swipe gesture , returns the requested action by the user and updates UI accordingly.
    func updateActionFeedback(xProgress: CGFloat, yProgress: CGFloat) {

        let newAction: SwipeAction? = {
            if yProgress > 0.9 { return .dismiss }
            if xProgress > 0.9 { return .approve }
            if xProgress < -0.9 { return .delete }
            return nil
        }()

        if newAction != activeAction {
            activeAction = newAction
            feedbackTriggered = false
        }

        if let _ = activeAction, !feedbackTriggered {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            feedbackTriggered = true
        }
    }

    var bottomControls: some View {
        HStack {
            Button { deleteCurrent(animated: true) } label: {
                controlIcon(
                    systemName: "trash",
                    color: .red,
                    isActive: activeAction == .delete
                )
            }

            Spacer()

            Button { resetCard() } label: {
                controlIcon(
                    systemName: "arrow.clockwise",
                    color: .gray,
                    isActive: false
                )
            }

            Spacer()

            Button { approveCurrent(animated: true) } label: {
                controlIcon(
                    systemName: "hand.thumbsup.fill",
                    color: .green,
                    isActive: activeAction == .approve
                )
            }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 16)
    }
    
    private var likeProgress: CGFloat {
        max(0, dragOffset.width / swipeThresholdX)
    }

    private var deleteProgress: CGFloat {
        max(0, -dragOffset.width / swipeThresholdX)
    }

    private var dismissProgress: CGFloat {
        max(0, dragOffset.height / swipeThresholdY)
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
        
        activeAction = nil
        feedbackTriggered = false

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
        activeAction = nil
        feedbackTriggered = false
        
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

    func controlIcon(
        systemName: String,
        color: Color,
        isActive: Bool
    ) -> some View {
        Image(systemName: systemName)
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(color)
            .frame(width: 46, height: 46)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(color.opacity(isActive ? 0.28 : 0.12))
            )
            .scaleEffect(isActive ? 1.08 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.8), value: isActive)
    }
    
    var emptyState: some View {
        Text("All items organised")
            .foregroundStyle(.secondary)
            .font(.headline)
    }
}

/// Private enum to allow users to interact with certain swipe actions
enum SwipeAction {
    case approve, delete, dismiss
}
