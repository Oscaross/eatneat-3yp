//
//  ItemDetailView.swift
//  EatNeat
//
//  Created by Oscar Horner on 18/10/2025.
//

import Foundation
import SwiftUI

struct PantryItemCardView: View {
    let item: PantryItem
    let onTap: () -> Void

    // Formats the weight into a readable string
    private var weightText: String? {
        guard let qty = item.weightQuantity,
              let unit = item.weightUnit else {
            return nil
        }

        // Avoid showing .0 for whole numbers
        let valueString: String
        if qty == floor(qty) {
            valueString = String(format: "%.0f", qty)
        } else {
            valueString = String(format: "%.2f", qty)
        }

        return "\(valueString) \(unit.rawValue)"
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            
            // ITEM NAME
            Text(item.name)
                .font(.headline)
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 4)

            // QUANTITY (e.g., 2x)
            Text("\(item.quantity)x")
                .font(.subheadline)
                .foregroundColor(.secondary)

            // WEIGHT (if available)
            if let weightText = weightText {
                Text(weightText)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .frame(
            width: min(UIScreen.main.bounds.width * 0.35, 140),
            height: min(UIScreen.main.bounds.width * 0.32, 132)
        )
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppStyle.containerGray, lineWidth: 2)
        )
        .shadow(color: Color.black.opacity(0.06), radius: 3, x: 0, y: 1)
        .onTapGesture {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()

            onTap()
        }
    }
}
