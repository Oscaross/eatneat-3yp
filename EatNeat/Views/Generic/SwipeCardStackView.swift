//
//  SwipeCardStackView.swift
//  EatNeat
//
//  Created by Oscar Horner on 03/02/2026.
//
// Represents a swiping card stack that handles swipe gestures for approve, delete, and dismiss actions.

import SwiftUI

struct SwipeCardStackView<Item: Identifiable, Content: View>: View {

    let items: [Item]
    let onAction: (SwipeCardAction) -> Void
    let onSwipeProgress: (SwipeCardAction?, Double) -> Void
    @ViewBuilder let content: (Item) -> Content

    // Under-card animation is driven by top-card progress only
    @State private var swipeProgress: CGFloat = 0

    // Tunables
    private let underYOffset: CGFloat = 10
    private let underScale: CGFloat = 0.96

    var body: some View {
        ZStack {
            if let underItem {
                content(underItem)
                    .scaleEffect(underCardScale)
                    .offset(y: underCardOffset)
                    .allowsHitTesting(false)
            }

            if let topItem {
                TopSwipeCard(
                    item: topItem,
                    content: content,
                    onProgress: { p in
                        swipeProgress = p
                    },
                    onSwipeProgress: onSwipeProgress,
                    onDismissed: { action in
                        // Ensure under-card snaps back cleanly before data mutation
                        withTransaction(Transaction(animation: nil)) {
                            swipeProgress = 0
                        }
                        onAction(action)
                    }
                )
                .id(topItem.id) // <- each top card has isolated swipe state
            }
        }
    }

    private var topItem: Item? { items.last }
    private var underItem: Item? { items.dropLast().last }

    private var underCardScale: CGFloat {
        underScale + (1 - underScale) * swipeProgress
    }

    private var underCardOffset: CGFloat {
        underYOffset * (1 - swipeProgress)
    }
}

private struct TopSwipeCard<Item: Identifiable, Content: View>: View {
    
    let item: Item
    let content: (Item) -> Content
    let onProgress: (CGFloat) -> Void
    let onSwipeProgress: (SwipeCardAction?, Double) -> Void
    let onDismissed: (SwipeCardAction) -> Void

    // Top-card physics (isolated per card)
    @State private var dragOffset: CGSize = .zero
    @State private var rotation: Double = 0
    @State private var isDismissing = false

    // Tunables
    private let swipeThresholdX: CGFloat = 120
    private let maxRotation: Double = 14
    private let maxDragX: CGFloat = 200

    var body: some View {
        content(item)
            .offset(dragOffset)
            .rotationEffect(.degrees(rotation), anchor: .bottom)
            .highPriorityGesture(dragGesture)
            .onChange(of: dragOffset.width) { _, newX in
                let p = min(1, abs(newX) / swipeThresholdX)
                onProgress(p)
            }
            .onAppear {
                onProgress(0)
            }
            .onDisappear {
                onProgress(0)
                onSwipeProgress(nil, 0)
            }
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                guard !isDismissing else { return }

                let rawX = value.translation.width
                let clampedX = max(-maxDragX, min(maxDragX, rawX))

                dragOffset = CGSize(width: clampedX, height: 0)
                rotation = Double(clampedX / maxDragX) * maxRotation

                let progress = min(1, abs(clampedX) / swipeThresholdX) // 0...1

                let direction: SwipeCardAction? =
                    clampedX > 0 ? .approve :
                    clampedX < 0 ? .delete :
                    nil

                onSwipeProgress(direction, Double(progress))
            }
            .onEnded { value in
                guard !isDismissing else { return }

                let x = value.translation.width
                if x > swipeThresholdX {
                    dismiss(.approve, direction: .right)
                } else if x < -swipeThresholdX {
                    dismiss(.delete, direction: .left)
                } else {
                    withAnimation(.spring(response: 0.28, dampingFraction: 0.85)) {
                        reset()
                    }
                    // If we didn't dismiss, explicitly clear progress
                    onSwipeProgress(nil, 0)
                }
            }
    }

    private enum Direction { case left, right }

    private func dismiss(_ action: SwipeCardAction, direction: Direction) {
        guard !isDismissing else { return }
        isDismissing = true

        // reset button scaling immediately
        onSwipeProgress(nil, 0)

        let screenW = UIScreen.main.bounds.width
        let sign: CGFloat = direction == .left ? -1 : 1

        withAnimation(.easeIn(duration: 0.25)) {
            dragOffset = CGSize(width: sign * screenW * 1.6, height: 0)
            rotation = direction == .left ? -maxRotation * 1.4 : maxRotation * 1.4
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            onDismissed(action)
        }
    }

    private func reset() {
        dragOffset = .zero
        rotation = 0
        onProgress(0)
    }
}

enum SwipeCardAction {
    case approve
    case delete
}
