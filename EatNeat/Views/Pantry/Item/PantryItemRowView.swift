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
        HStack(alignment: .center) {

            // NAME
            Text(item.name)
                .font(.body)
                .lineLimit(1)
                .truncationMode(.tail)

            Spacer()

            Text(item.subtitleText)
                .foregroundColor(.secondary)
                .font(.body)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(Color.clear)
    }
}
