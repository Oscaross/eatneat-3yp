//
//  CapsuleView.swift
//  EatNeat
//
//  Created by Oscar Horner on 29/01/2026.
//
// Represents clickable rounded rectangle capsules, such as label tooltips or buttons

import SwiftUI

struct CapsuleView: View {
    let text: String
    let color: Color
    let heavy: Bool // "heavy" capsules have a more opaque background and bolder text, they indicate selected or important capsules
    let action: () -> Void

    private let cornerRadius: CGFloat = 8

    var body: some View {
        Button {
            action()
        } label: {
            Text(text)
                .font(.system(size: 13, weight: (heavy) ? .bold : .semibold))
                .foregroundColor(color)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(heavy ? color.opacity(0.18) : color.opacity(0.08))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(color.opacity(heavy ? 0.6 : 0.0), lineWidth: heavy ? 1.6 : 0)
                )
                .animation(.easeInOut(duration: 0.18), value: heavy) // smoothly animate changes to heavy state
        }
        .buttonStyle(.plain)
    }
}
