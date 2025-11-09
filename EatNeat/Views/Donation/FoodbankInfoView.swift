//
//  FoodbankInfoView.swift
//  EatNeat
//
//  Created by Oscar Horner on 09/11/2025.
//
// Shown when the dialog sheet for a specific foodbank is called

import SwiftUI

struct FoodbankInfoView: View {
    var foodbank: FoodbankNeeds

    var body: some View {
        VStack(spacing: 16) {
            Text(foodbank.name)
                .font(.title2)
                .bold()

            if let distance = foodbank.distance {
                Text(String(format: "%.1f km away", distance / 1000))
                    .foregroundColor(.secondary)
            }

            Divider()

            Spacer()
            Button("Close") { dismiss() }
                .buttonStyle(.borderedProminent)
        }
        .padding()
        .presentationDetents([.medium, .large])
    }

    @Environment(\.dismiss) private var dismiss
}

