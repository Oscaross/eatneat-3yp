//
//  EmptyPantryView.swift
//  EatNeat
//
//  Created by Oscar Horner on 04/02/2026.
//
// View shown if no items match the selected criteria within some search or filter controller in the pantry.

import SwiftUI

struct EmptyPantryView: View {

    /// Optional explanatory text shown under the title
    let tooltip: String?

    /// Optional custom icon (defaults to archivebox)
    var systemImage: String = "archivebox"

    var body: some View {
        VStack(spacing: 16) {

            Image(systemName: systemImage)
                .font(.system(size: 64, weight: .regular))
                .foregroundStyle(.secondary)
                .symbolRenderingMode(.hierarchical)

            VStack(spacing: 6) {
                Text("Empty Pantry")
                    .font(.title3)
                    .fontWeight(.semibold)

                if let tooltip, !tooltip.isEmpty {
                    Text(tooltip)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}
