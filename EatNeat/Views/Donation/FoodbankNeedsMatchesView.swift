//
//  FoodbankNeedsMatchesView.swift
//  EatNeat
//
//  Created by Oscar Horner on 24/11/2025.
//

import SwiftUI

struct FoodbankNeedsMatchesView: View {
    var foodbank: FoodbankNeeds
    @State private var selectedNeeds: Set<Int> = []
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var donationViewModel: DonationViewModel

    private let collapsedLimit = 10
    
    init(foodbank: FoodbankNeeds, currSelectedNeeds: Set<Int> = []) {
        self.selectedNeeds = currSelectedNeeds
        self.foodbank = foodbank
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {

            header

            needsScroller

            matchesScroller
        }
    }

    // MARK: - Header (Needs count + Clear button)
    private var header: some View {
        HStack {
            let count = foodbank.needsList.count
            Text("\(count) \(count == 1 ? "NEED" : "NEEDS")")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            if let updated = foodbank.needsLastUpdated {
                let timeElapsed = Date().timeIntervalSince(updated)
                let threeMonths: TimeInterval = 60 * 60 * 24 * 90
                
                let relativeString = TimeUnit.compactRelativeString(from: updated) // formatted string ie. (3mo ago)
                
                if (timeElapsed < threeMonths) {
                    Text(updated.formatted(date: .abbreviated, time: .shortened))
                        .chipStyle(background: AppStyle.primary.opacity(AppStyle.backgroundOpacity(darkMode: colorScheme == .dark)))
                }
                else {
                    Text("\(updated.formatted(date: .abbreviated, time: .omitted)) (\(relativeString))")
                        .chipStyle(background: .orange.opacity(AppStyle.backgroundOpacity(darkMode: colorScheme == .dark)))
                }

            }
            
            Spacer()

            if !selectedNeeds.isEmpty {
                ClearButtonView(action: {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    selectedNeeds.removeAll()
                })
            }
        }
    }

    // MARK: - Needs Tag Scroller
    private var needsScroller: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(foodbank.needsList, id: \.id) { need in
                    let isSelected = selectedNeeds.contains(need.id)
                    PillView(
                        text: need.name.capitalized,
                        color: AppStyle.accentBlue,
                        isSelected: isSelected
                    ) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            if isSelected {
                                selectedNeeds.remove(need.id)
                            } else {
                                selectedNeeds.insert(need.id)
                            }
                        }
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }

    @State private var itemToEdit: PantryItem?
    @State private var showingEditor = false
    
    // MARK: - Matches Scroller
    private var matchesScroller: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("MATCHES")
                .font(.subheadline)
                .foregroundColor(.secondary)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {

                    let filteredNeeds = foodbank.needsList.filter {
                        selectedNeeds.isEmpty || selectedNeeds.contains($0.id)
                    }

                    // Collect all matched items for the filtered needs
                    let allMatchedItems = filteredNeeds.flatMap { need in
                        foodbank.matchedNeeds[need.id] ?? []
                    }

                    if allMatchedItems.isEmpty {
                        // center message
                        HStack {
                            Spacer()
                            Text("No matches found!")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                                .padding(.vertical, 4)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                    } else {
                        // Show actual matches
                        ForEach(filteredNeeds, id: \.id) { need in
                            let items = foodbank.matchedNeeds[need.id] ?? []

                            ForEach(items) { item in
                                PantryItemCardView(item: item) {
                                    donationViewModel.registerDonation(foodbank: foodbank, item: item)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 4)
                .padding(.vertical, 2)
            }
        }
        
    }
}
