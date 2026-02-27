//
//  AppBackgroundView.swift
//  EatNeat
//
//  Created by Oscar Horner on 26/02/2026.
//
// A global style for background which gives the app a more modern iOS 26 feel

import SwiftUI

struct AppBackgroundView<Content: View>: View {
    @Environment(\.colorScheme) private var colorScheme
    @ViewBuilder var content: Content

    var body: some View {
        ZStack {
            // Subtle, adaptive gradient wash
            LinearGradient(
                colors: backgroundColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            Color.black.opacity(colorScheme == .dark ? 0.04 : 0.03)
                .blendMode(.overlay)
                .ignoresSafeArea()

            content
        }
    }

    private var backgroundColors: [Color] {
        if colorScheme == .dark {
            return [
                Color(.systemBackground).opacity(0.95),
                Color.indigo.opacity(0.18)
            ]
        } else {
            return [
                Color(.systemBackground).opacity(0.95),
                Color.blue.opacity(0.12)
            ]
        }
    }
}
