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

    let trueLabel: String
    let falseLabel: String
    let color: Color 

    var body: some View {
        CapsuleView(
            text: value ? trueLabel : falseLabel,
            color: color
        ) {
            toggle()
        }
        .animation(.easeInOut(duration: 0.25), value: value)
        .accessibilityValue(value ? trueLabel : falseLabel)
    }

    private func toggle() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        value.toggle()
    }
}
