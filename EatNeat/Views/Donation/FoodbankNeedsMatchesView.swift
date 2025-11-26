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
                
                let relativeString = compactRelativeString(from: updated) // formatted string ie. (3mo ago)
                
                if (timeElapsed < threeMonths) {
                    Text("\(updated.formatted(date: .abbreviated, time: .shortened))")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(AppStyle.lightBlueBackground)
                        )
                }
                else {
                    // Older than 3 months → date + (relative)
                     Text("\(updated.formatted(date: .abbreviated, time: .omitted)) (\(relativeString))")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(AppStyle.yellowBackground)
                        )
                }

            }
            
            Spacer()

            if !selectedNeeds.isEmpty {
                Button {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        selectedNeeds.removeAll()
                    }
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                } label: {
                    Text("Clear")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.red)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color.red.opacity(0.1)))
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: - Needs Tag Scroller
    private var needsScroller: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(foodbank.needsList, id: \.id) { need in
                    let isSelected = selectedNeeds.contains(need.id)

                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            if isSelected {
                                selectedNeeds.remove(need.id)
                            } else {
                                selectedNeeds.insert(need.id)
                            }
                        }
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    } label: {
                        Text(need.name.capitalized)
                            .font(.system(size: 13, weight: .semibold))
                            .lineLimit(1)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(isSelected ? AppStyle.accentBlue : Color.clear)
                            )
                            .foregroundColor(isSelected ? .white : AppStyle.accentBlue)
                            .overlay(
                                Capsule().stroke(AppStyle.accentBlue, lineWidth: 1.4)
                            )
                    }
                    .buttonStyle(.plain)
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
                                    itemToEdit = item
                                    showingEditor = true
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
    
    private func compactRelativeString(from date: Date) -> String {
        let seconds = Int(Date().timeIntervalSince(date))

        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 30 * day
        let year = 365 * day

        switch seconds {
        case ..<60:
            return "just now"
        case ..<hour:
            return "\(seconds / minute)m ago"
        case ..<day:
            return "\(seconds / hour)h ago"
        case ..<week:
            return "\(seconds / day)d ago"
        case ..<(month):
            return "\(seconds / week)w ago"
        case ..<(year):
            return "\(seconds / month)mo ago"
        default:
            return "\(seconds / year)y ago"
        }
    }
}
