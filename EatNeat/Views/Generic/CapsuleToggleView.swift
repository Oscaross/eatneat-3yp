//
//  CapsuleToggleView.swift
//  EatNeat
//
//  Created by Oscar Horner on 29/01/2026.
//
// Allows users to toggle between two binary states with custom names, such as "Perishable" and "Non-perishable".

import SwiftUI

struct CapsuleToggleView: View {
    @Binding var value: Bool

    let trueLabel: CapsuleContent
    let falseLabel: CapsuleContent
    let color: Color

    var body: some View {
        CapsuleView(
            content: value ? trueLabel : falseLabel,
            color: color,
            heavy: value
        ) {
            toggle()
        }
        .animation(.easeInOut(duration: 0.25), value: value)
        .accessibilityValue(value ? trueLabel.accessibilityLabel : falseLabel.accessibilityLabel)
    }

    private func toggle() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        value.toggle()
    }
}
