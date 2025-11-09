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
    
    @State private var selectedNeeds: Set<String> = []
    @State private var showAllNeeds: Bool = false
    @State private var needsHeight: CGFloat = 0
    @State private var rowThresholdHeight: CGFloat = 95 // height of ~2 rows on most screens

    private struct NeedsHeightKey: PreferenceKey {
        static var defaultValue: CGFloat = 0
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = nextValue()
        }
    }

    // Generous character truncation limit
    private func truncated(_ text: String, limit: Int) -> String {
        guard text.count > limit else { return text }
        let index = text.index(text.startIndex, offsetBy: limit - 3)
        return "\(text[..<index])..."
    }

    // Choose how many labels to show (collapsed vs expanded)
    private func displayedNeeds(_ allKeys: [String]) -> [String] {
        guard !showAllNeeds else { return allKeys }
        // show only first 9–10 tags to roughly fit two rows
        return Array(allKeys.prefix(10))
    }

    // Compute tag width adaptively (media-query style)
    private func tagWidth(for totalWidth: CGFloat) -> CGFloat {
        switch totalWidth {
        case 0..<350: return 120   // small iPhones
        case 350..<500: return 140 // standard iPhones
        case 500..<700: return 160 // large / landscape
        default: return 180        // iPad
        }
    }


    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Header row
            HStack {
                HStack(spacing: 6) {
                    Text(name)
                        .font(.headline)
                        .lineLimit(1)
                        .minimumScaleFactor(0.9)

                    Button {
                        print("Info tapped for \(name)")
                    } label: {
                        Image(systemName: "info.circle")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.blue.opacity(0.8))
                    }
                    .buttonStyle(.plain) // prevents highlight effect
                    .accessibilityLabel("More info about \(name)")
                }

                Spacer()

                Text(distance)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Divider()

            // NEEDS section
            VStack(alignment: .leading, spacing: 10) {
                // Header with "Clear Selection"
                HStack {
                    Text("NEEDS")
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Spacer()

                    if !selectedNeeds.isEmpty {
                        Button {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                selectedNeeds.removeAll()
                            }
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        } label: {
                            Text("Clear Selection")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.red)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Capsule().fill(Color.red.opacity(0.1)))
                        }
                        .buttonStyle(.plain)
                    }
                }

                // Grid of need tags
                GeometryReader { geo in
                    let totalWidth = geo.size.width
                    let columns = [GridItem(.adaptive(minimum: tagWidth(for: totalWidth)), spacing: 8)]

                    LazyVGrid(columns: columns, alignment: .leading, spacing: 8) {
                        ForEach(displayedNeeds(Array(needs.keys)), id: \.self) { needKey in
                            let isSelected = selectedNeeds.contains(needKey)

                            Button {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    if isSelected {
                                        selectedNeeds.remove(needKey)
                                    } else {
                                        selectedNeeds.insert(needKey)
                                    }
                                }
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            } label: {
                                Text(truncated(needKey.capitalized, limit: 22)) // generous limit
                                    .font(.system(size: 13, weight: .semibold))
                                    .lineLimit(1)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .frame(minWidth: 90, maxWidth: .infinity)
                                    .background(
                                        Capsule().fill(
                                            isSelected ? AppStyle.accentBlue : Color.clear
                                        )
                                    )
                                    .foregroundColor(isSelected ? .white : AppStyle.accentBlue)
                                    .overlay(
                                        Capsule().stroke(AppStyle.accentBlue, lineWidth: 1.6)
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .background(
                        GeometryReader { innerGeo in
                            Color.clear
                                .preference(key: NeedsHeightKey.self, value: innerGeo.size.height)
                        }
                    )
                }
                .frame(minHeight: 100)
                .onPreferenceChange(NeedsHeightKey.self) { height in
                    needsHeight = height
                }

                // Show More / Less toggle (only if grid overflows)
                if needsHeight > rowThresholdHeight {
                    Button {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            showAllNeeds.toggle()
                        }
                    } label: {
                        Text(showAllNeeds ? "Show Less..." : "Show More...")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(AppStyle.accentBlue)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.plain)
                    .transition(.opacity)
                }
            }
            .padding(.top, 4)


            // MATCHES section
            VStack(alignment: .leading, spacing: 8) {
                Text("MATCHES")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 16) {
                        // Filter needs by selection
                        ForEach(Array(needs)
                                .filter { selectedNeeds.isEmpty || selectedNeeds.contains($0.key) },
                                id: \.key) { pair in

                            let needKey = pair.key
                            let items: [PantryItem] = pair.value ?? []

                            if !items.isEmpty {
                                ForEach(items, id: \.id) { item in
                                    PantryItemCard(item: item)
                                }
                            }
                            else {
                                Text("No matches found!")
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }

        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.clear)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(AppStyle.containerBackground, lineWidth: 1.2)
        )
        .cornerRadius(16)
        .padding(.horizontal)
    }
}

#Preview {
    FoodbankCardView(
        name: "Coventry Central Foodbank",
        needs: [
            "Tinned Goods": [PantryItem(quantity: 1, name: "Baked Beans", category: Category.none), PantryItem(quantity: 1, name: "Tomatoes", category: Category.none)],
            "Cereal": [PantryItem(quantity: 1, name: "Cornflakes", category: Category.none)],
            "Toiletries": nil
        ],
        distance: "1.4 km"
    )
    .padding()
    .background(Color(.systemBackground))
}

