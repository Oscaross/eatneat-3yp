//
//  ChipStyleView.swift
//  EatNeat
//
//  Created by Oscar Horner on 21/02/2026.
//
// A custom view modifier that overlays a chip style onto tooltips/info that the app provides in various places

import SwiftUI

struct ChipStyle: ViewModifier {
    var background: Color
    var foreground: Color = .secondary
    var cornerRadius: CGFloat = 8

    func body(content: Content) -> some View {
        content
            .font(.caption)
            .fontWeight(.medium)
            .foregroundColor(foreground)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(background)
            )
    }
}

extension View {
    func chipStyle(
        background: Color,
        foreground: Color = .secondary,
        cornerRadius: CGFloat = 8
    ) -> some View {
        modifier(
            ChipStyle(
                background: background,
                foreground: foreground,
                cornerRadius: cornerRadius
            )
        )
    }
}
