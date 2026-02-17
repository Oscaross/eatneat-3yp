//
//  AddButtonView.swift
//  EatNeat
//
//  Created by Oscar Horner on 14/02/2026.
//
// Abstraction for the add button which is a gray + that routes the user to the correct location. Used for a quick add, such as adding a label, category or filter.

import SwiftUI

struct AddButtonView: View {

    var color: Color = .gray
    var systemImage: String = "plus"
    var heavy: Bool = false
    var hapticStyle: UIImpactFeedbackGenerator.FeedbackStyle = .medium
    var action: () -> Void

    var body: some View {
        CapsuleView(
            content: .icon(systemName: systemImage),
            color: color,
            heavy: heavy
        ) {
            UIImpactFeedbackGenerator(style: hapticStyle).impactOccurred()
            action()
        }
    }
}
