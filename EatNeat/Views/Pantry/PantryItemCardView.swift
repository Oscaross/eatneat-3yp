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

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(item.name)
                .font(.headline)
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true) // allows wrapping
            Spacer()
            Text("\(item.quantity)x")
                .font(.subheadline)
                .foregroundColor(.secondary)
            if let weight = item.weight {
                Text("\(Int(weight))g")
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
    }
}

