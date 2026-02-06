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

    @ViewBuilder
    let content: (Item) -> Content
    

    // Top-card physics
    @State private var dragOffset: CGSize = .zero
    @State private var rotation: Double = 0
    @State private var isDismissing = false

    // Tunables
    private let swipeThresholdX: CGFloat = 120
    private let swipeThresholdY: CGFloat = 120
    private let maxRotation: Double = 14
    private let underYOffset: CGFloat = 10
    private let underScale: CGFloat = 0.96
    private let maxDragX: CGFloat = 200

    var body: some View {
        ZStack {
            if let underItem {
                content(underItem)
                    .scaleEffect(underCardScale)
                    .offset(y: underCardOffset)
                    .allowsHitTesting(false)
            }

            if let topItem {
                content(topItem)
                    .offset(dragOffset)
                    .rotationEffect(.degrees(rotation), anchor: .bottom)
                    .gesture(dragGesture)
                    .animation(.spring(response: 0.28, dampingFraction: 0.85), value: dragOffset)
                    .animation(.spring(response: 0.28, dampingFraction: 0.85), value: items.map(\.id))
            }
        }
    }

    // MARK: - Card selection

    private var topItem: Item? {
        items.last
    }

    private var underItem: Item? {
        items.dropLast().last
    }

    // MARK: - Under-card animation

    private var progress: CGFloat {
        min(1, abs(dragOffset.width) / swipeThresholdX)
    }

    private var underCardScale: CGFloat {
        underScale + (1 - underScale) * progress
    }

    private var underCardOffset: CGFloat {
        underYOffset * (1 - progress)
    }

    // MARK: - Gesture

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                let rawX = value.translation.width
                let clampedX = max(-maxDragX, min(maxDragX, rawX))

                dragOffset = CGSize(width: clampedX, height: 0)
                rotation = Double(clampedX / maxDragX) * maxRotation
            }
            .onEnded { value in
                let x = value.translation.width

                if x > swipeThresholdX {
                    dismiss(.approve, direction: .right)
                } else if x < -swipeThresholdX {
                    dismiss(.delete, direction: .left)
                } else {
                    reset()
                }
            }
    }

    private func handleEnd(_ t: CGSize) {
        if t.width > swipeThresholdX {
            dismiss(.approve, direction: .right)
        } else if t.width < -swipeThresholdX {
            dismiss(.delete, direction: .left)
        } else {
            reset()
        }
    }

    enum Direction { case left, right }

    private func dismiss(_ action: SwipeCardAction, direction: Direction) {
        guard !isDismissing else { return }
        isDismissing = true

        // Animate the current top card offscreen
        withAnimation(.spring(response: 0.25, dampingFraction: 0.85)) {
            dragOffset = offscreenOffset(direction)
            rotation = offscreenRotation(direction)
        }

        // After the fly-off finishes reset for the next card
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
            reset()

            onAction(action)

            isDismissing = false
        }
    }
    
    /// Given a direction, returns the offset required to put the card off the screen
    private func offscreenOffset(_ direction: Direction) -> CGSize {
        let screenW = UIScreen.main.bounds.width

        switch direction {
        case .left:
            return CGSize(width: -screenW, height: 0)
        case .right:
            return CGSize(width: screenW, height: 0)
        }
    }
    
    /// Given a direction, returns the rotation required to rotate the card offscreen
    private func offscreenRotation(_ direction: Direction) -> Double {
        direction == .left ? -maxRotation : maxRotation
    }


    private func reset() {
        dragOffset = .zero
        rotation = 0
    }
}

enum SwipeCardAction {
    case approve
    case delete
    case dismiss
}
