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
    let shouldChangeAppearanceOnToggle: Bool
    
    init(value: Binding<Bool>, trueLabel: CapsuleContent, falseLabel: CapsuleContent, color: Color, shouldChangeAppearanceOnToggle: Bool = true) {
        self._value = value
        self.trueLabel = trueLabel
        self.falseLabel = falseLabel
        self.color = color
        self.shouldChangeAppearanceOnToggle = shouldChangeAppearanceOnToggle
    }

    var body: some View {
        CapsuleView(
            content: value ? trueLabel : falseLabel,
            color: color,
            heavy: value && shouldChangeAppearanceOnToggle
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
