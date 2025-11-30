//
//  Style.swift
//  EatNeat
//
//  Created by Oscar Horner on 18/10/2025.
//
// Cards are a common UI element where we want to elevate information collections (such as foodbank data) over the system background.
// Chips are rounded subtle colour containers, and used for tag-like interactable elements or minor button actions.

import SwiftUI

enum AppStyle {
    // MARK: Main styling
    
    /// App-wide colors
    static let accentBlue = Color.blue.opacity(0.8)
    static let primary = Color.blue
    static let secondary = Color.indigo
    static let lightBlueBackground = Color.blue.opacity(0.08)
    static let yellowBackground = Color.yellow.opacity(0.3)
    static let containerGray = Color(.systemGray6).opacity(0.3)
    static let secondaryContainerGray = Color(.systemGray).opacity(0.2)
    
    /// Text styles
    struct Text {
        static let sectionHeader = Font.system(.headline, weight: .bold)
        static let body = Font.system(.body)
    }
    
    // MARK: Card styling
    
    /// Centralised card styling
    struct CardStyle: ViewModifier {
        let padding: CGFloat
        let cornerRadius: CGFloat
        let shadowRadius: CGFloat
        let shadowY: CGFloat

        func body(content: Content) -> some View {
            content
                .padding(padding)
                .background(AppStyle.cardBackground)
                .cornerRadius(cornerRadius)
                .shadow(color: AppStyle.cardShadow,
                        radius: shadowRadius,
                        x: 0,
                        y: shadowY)
        }
    }
    
    static func card(
        padding: CGFloat = 12,
        cornerRadius: CGFloat = AppStyle.cardCornerRadius,
        shadowRadius: CGFloat = 6,
        shadowY: CGFloat = 3
    ) -> CardStyle {
        CardStyle(
            padding: padding,
            cornerRadius: cornerRadius,
            shadowRadius: shadowRadius,
            shadowY: shadowY
        )
    }
    
    /// Universal radius for all elevated cards / containers
    static let cardCornerRadius: CGFloat = 12

    /// Adaptive card background (light/dark friendly)
    static var cardBackground: Color {
        Color("CardBackground")
    }

    /// Universal shadow colour, works in light & dark mode
    static var cardShadow: Color {
        Color.black.opacity(0.15)
    }
}

extension View {
    func cardStyle(
        padding: CGFloat = 12,
        cornerRadius: CGFloat = AppStyle.cardCornerRadius,
        shadowRadius: CGFloat = 6,
        shadowY: CGFloat = 3
    ) -> some View {
        self.modifier(
            AppStyle.card(
                padding: padding,
                cornerRadius: cornerRadius,
                shadowRadius: shadowRadius,
                shadowY: shadowY
            )
        )
    }
}
