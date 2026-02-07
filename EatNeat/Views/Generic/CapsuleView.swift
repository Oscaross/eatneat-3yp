//
//  CapsuleView.swift
//  EatNeat
//
//  Created by Oscar Horner on 29/01/2026.
//
// Represents clickable rounded rectangle capsules, such as label tooltips or buttons

import SwiftUI

struct CapsuleView: View {
    let content: CapsuleContent
    let color: Color
    let heavy: Bool
    let action: () -> Void

    private let cornerRadius: CGFloat = 8

    var body: some View {
        Button(action: action) {
            capsuleLabel
                .font(.system(size: 13, weight: heavy ? .bold : .semibold))
                .foregroundColor(color)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(heavy ? color.opacity(0.18) : color.opacity(0.08))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(
                            color.opacity(heavy ? 0.5 : 0.0),
                            lineWidth: heavy ? 1.2 : 0
                        )
                )
                .animation(.easeInOut(duration: 0.18), value: heavy)
        }
        .buttonStyle(.plain)
    }
}

private extension CapsuleView {

    @ViewBuilder
    var capsuleLabel: some View {
        switch content {
        case .text(let text):
            Text(text)

        case .icon(let systemName):
            Image(systemName: systemName)

        case .textAndIcon(let text, let systemName):
            HStack(spacing: 4) {
                Image(systemName: systemName)
                Text(text)
            }
        }
    }
}
