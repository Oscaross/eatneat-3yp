//
//  FoodbankCardView.swift
//  EatNeat
//
//  Created by Oscar Horner on 02/11/2025.
//

import SwiftUI

struct FoodbankCardView: View {
    var name: String
    var needsList: [Need]
    var matchedNeeds: [Int: [PantryItem]]
    var distance: String

    @State private var selectedNeeds: Set<Int> = []
    @State private var showAllNeeds: Bool = false

    // Limit of needs shown when collapsed
    private let collapsedLimit = 10

    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            headerSection
            Divider()
            needsSection
            matchesSection
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
                .buttonStyle(.plain)
            }

            Spacer()

            Text(distance)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }

    // MARK: - Needs Section
    private var needsSection: some View {
        VStack(alignment: .leading, spacing: 10) {

            HStack {
                let needCount = needsList.count
                Text("\(needCount) \(needCount == 1 ? "NEED" : "NEEDS")")
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

            // Horizontal list of capsule tags
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(needsList, id: \.id) { need in
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
        .padding(.top, 4)
    }

    // MARK: - Matches Section
    private var matchesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("MATCHES")
                .font(.subheadline)
                .foregroundColor(.secondary)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {

                    ForEach(needsList.filter { selectedNeeds.isEmpty || selectedNeeds.contains($0.id) }, id: \.id) { need in

                        let items = matchedNeeds[need.id] ?? []

                        if items.isEmpty {
                            Text("No matches found!")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                                .padding(.vertical, 4)
                        } else {
                            ForEach(items, id: \.id) { item in
                                PantryItemCardView(item: item)
                                    .fixedSize()
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
