//
//  EmptyPantryView.swift
//  EatNeat
//
//  Created by Oscar Horner on 04/02/2026.
//
// View shown if no items match the selected criteria within some search or filter controller in the pantry.

import SwiftUI

struct EmptyPantryView: View {
    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: "tray")
                .font(.system(size: 52, weight: .semibold))
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.secondary)

            Text("No items to show!")
                .font(.title3.weight(.semibold))

            Text("Scan items into your pantry or add them manually.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 18)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(.separator.opacity(0.35), lineWidth: 1)
        )
        .padding(.horizontal, 20)
    }
}
