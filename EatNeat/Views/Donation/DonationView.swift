//
//  DonationView.swift
//  EatNeat
//
//  Created by Oscar Horner on 26/10/2025.
//

import SwiftUI

struct DonationView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Button(action: {
                    print("Donation backend queried!")
                }) {
                    Text("Donate")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 50)
                        .padding(.vertical, 15)
                        .foregroundColor(.white)
                        .background(AppStyle.accentBlue)
                        .cornerRadius(12)
                        .shadow(radius: 4)
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Give Food")
        }
    }
}

#Preview {
    DonationView()
}
