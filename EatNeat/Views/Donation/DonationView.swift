//
//  DonationView.swift
//  EatNeat
//
//  Created by Oscar Horner on 26/02/2026.
//
// Viewer which allows users to see their nearby foodbank

import SwiftUI

struct DonationView: View {

    // @EnvironmentObject var donationVM: DonationViewModel
    @State private var foodbanks = SampleData.sampleFoodbankDonationData()
    @State private var selectedFoodbankID: String?

    var body: some View {
        NavigationStack {

            ScrollView {
                VStack(alignment: .leading, spacing: 6) {
                    header
                        .padding(.horizontal, 16)

                    carousel

                    Spacer()
                }
                .padding(.top, 4)
                .padding(.bottom, 16)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        EmptyView()  // Placeholder
                    } label: {
                        Image(systemName: "questionmark.circle")
                            .font(.system(size: 18, weight: .semibold))
                    }
                }
            }
        }
        .onAppear {
            if selectedFoodbankID == nil {
                selectedFoodbankID = foodbanks.first?.id
            }
        }
        .scrollDisabled(_: true)
    }

    // MARK: Header

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Local foodbanks")
                .font(.title2.weight(.semibold))

            Text("Foodbanks across the UK publish lists of items they urgently need. If you can, add an item or two when you next shop using personalised suggestions tailored to the needs of your local community! ")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    // MARK: Carousel

    @State private var selectedFoodbank: FoodbankCard?

    private var carousel: some View {
        let screenH = UIScreen.main.bounds.height
        let cardHeight = screenH * 0.64

        return ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack() {
                ForEach(foodbanks) { foodbank in
                    FoodbankCardView(foodbank: foodbank)
                        // width: one “page” with side spacing, auto-centers with viewAligned
                        .containerRelativeFrame(.horizontal, count: 1, span: 1, spacing: 32)
                        .frame(height: cardHeight)
                        .contentShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                        .onTapGesture { selectedFoodbank = foodbank }
                        .padding(.all, 16)
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
        .frame(height: cardHeight)
    }
}

