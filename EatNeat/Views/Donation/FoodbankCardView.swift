//
//  FoodbankCardView.swift
//  EatNeat
//
//  Created by Oscar Horner on 02/11/2025.
//

import SwiftUI
import Foundation

struct FoodbankCardView: View {
    var name: String
    var needs: [String : [PantryItem]?] // need string (ie. "Tinned Goods") -> list of items
    var distance: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header row
            HStack {
                Text(name)
                    .font(.headline)
                Spacer()
                Text(distance)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Divider()
            
            // NEEDS section
            VStack(alignment: .leading, spacing: 8) {
                Text("NEEDS")
                    .font(.subheadline)

                // Tag container
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(Array(needs.keys), id: \.self) { needKey in
                            Text(needKey.capitalized)
                                .font(.system(size: 13, weight: .semibold))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Color.blue.opacity(0.15))
                                .foregroundColor(Color.blue)
                                .clipShape(Capsule())
                        }
                    }
                    .padding(.vertical, 4)
                }
                .frame(height: 60)
                .background(Color.white.opacity(0.4))
                .cornerRadius(8)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("MATCHES")
                    .font(.subheadline)
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white.opacity(0.4))
                    .frame(height: 60)
                    .overlay(Text("Matches content").foregroundColor(.secondary))
            }

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppStyle.containerBackground)
        .cornerRadius(16)
        .shadow(radius: 2, y: 1)
    }
}
