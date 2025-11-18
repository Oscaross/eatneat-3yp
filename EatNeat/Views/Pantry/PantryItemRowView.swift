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
        HStack {
            Text(item.name)
                .font(.body)
            Spacer()
            Text("\(Int(item.quantity)) pcs")
                .foregroundColor(.secondary)
        }
        .padding()
        .background(AppStyle.containerGray)
        .cornerRadius(8)
    }
}
