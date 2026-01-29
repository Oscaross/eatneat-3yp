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
    let action: () -> Void

    private let cornerRadius: CGFloat = 8

    var body: some View {
        Button {
            action()
        } label: {
            Text(text)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(color)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(color.opacity(0.1))
                )
        }
        .buttonStyle(.plain)
    }
}
