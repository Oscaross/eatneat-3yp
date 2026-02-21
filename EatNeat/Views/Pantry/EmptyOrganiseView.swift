//
//  EmptyOrganiseView.swift
//  EatNeat
//
//  Created by Oscar Horner on 21/02/2026.
//
// View to show the user that there are no cards left to flick through

import SwiftUI

struct EmptyOrganiseView: View {

    /// Optional custom icon (defaults to archivebox)
    var systemImage: String = "checkmark"

    var body: some View {
        VStack(spacing: 16) {

            Image(systemName: systemImage)
                .font(.system(size: 64, weight: .regular))
                .foregroundStyle(.secondary)
                .symbolRenderingMode(.hierarchical)

            VStack(spacing: 6) {
                Text("All done!")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text("All of your items are up to date and you have no more to sort. Add more items through the add button or re-enter the organise viewer to see items again.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}
