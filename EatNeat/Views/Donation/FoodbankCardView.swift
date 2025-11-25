//
//  FoodbankCardView.swift
//  EatNeat
//
//  Created by Oscar Horner on 02/11/2025.
//

import SwiftUI

struct FoodbankCardView: View {
    var foodbank: FoodbankNeeds

    @State private var selectedNeeds: Set<Int> = []
    @State private var showAllNeeds: Bool = false

    // Limit of needs shown when collapsed
    private let collapsedLimit = 10

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            headerSection
            Divider()
            FoodbankNeedsMatchesView(foodbank: foodbank, currSelectedNeeds: selectedNeeds)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppStyle.containerGray, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
        .padding(.horizontal)
    }

    // MARK: - Header
    private var headerSection: some View {
        HStack {
            HStack(spacing: 6) {
                Text(foodbank.name)
                    .font(.headline)
                    .lineLimit(1)
                    .minimumScaleFactor(0.9)
            }

            Spacer()
            
            Text(foodbank.formattedDistance())
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}
