//
//  ItemDetailView.swift
//  EatNeat
//
//  Created by Oscar Horner on 18/10/2025.
//

import Foundation
import SwiftUI

// If the user is using a card grid view
struct PantryItemCard: View {
    let item: PantryItem

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(item.name)
                .font(.headline)
                .foregroundColor(.primary)
                .lineLimit(1)
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
        .frame(width: min(UIScreen.main.bounds.width * 0.35, 140), height: min(UIScreen.main.bounds.width * 0.32, 132))
        .background(AppStyle.containerBackground)
        .cornerRadius(8)
        .shadow(radius: 2)
    }
}

// If the user is using a vertical list view
struct PantryItemRow: View {
    let item: PantryItem

    var body: some View {
        HStack {
            Text(item.name)
                .font(.body)
            Spacer()
            Text("\(Int(item.quantity)) pcs")
                .foregroundColor(.secondary)
        }
        .padding()
        .background(AppStyle.containerBackground)
        .cornerRadius(8)
    }
}
