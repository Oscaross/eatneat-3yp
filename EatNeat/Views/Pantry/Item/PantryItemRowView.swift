//
//  PantryItemListView.swift
//  EatNeat
//
//  Created by Oscar Horner on 09/11/2025.
//
// If the user is using a vertical list view

import SwiftUI

struct PantryItemRowView: View {
    let item: PantryItem
    
    var body: some View {
        HStack(spacing: 12) {
            
            Text(item.name)
                .font(.system(size: 15, weight: .medium))
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(item.subtitleText)
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
                .monospacedDigit()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .contentShape(Rectangle())
    }
}
