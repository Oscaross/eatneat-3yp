//
//  FoodbankCardView.swift
//  EatNeat
//
//  Created by Oscar Horner on 02/11/2025.
//

import SwiftUI

struct FoodbankCardView: View {

    let foodbank: FoodbankCard

    var body: some View {

        VStack(alignment: .leading, spacing: 16) {

            topSection
            youCouldHelpSection
            needsSection

            if !foodbank.surpluses.isEmpty {
                surplusSection
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(.thinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .strokeBorder(.white.opacity(0.12), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.15), radius: 18, y: 8)
        .frame(maxHeight: .infinity, alignment: .top) // all cards the same height and alignment, they dynamically resize
    }
    
    // MARK: Top Section

    private var topSection: some View {
        VStack(alignment: .leading, spacing: 4) {

            HStack {
                Text(foodbank.name)
                    .font(.headline.weight(.semibold))
                    .lineLimit(2)

                Spacer()

                if foodbank.isFavourite {
                    Image(systemName: "heart.fill")
                        .foregroundStyle(.red)
                }
            }

            let distance = foodbank.distanceText
            let updatedText = foodbank.needsLastUpdatedText
            if let updated = updatedText, !updated.isEmpty {
                Text("\(distance) • Updated \(updated)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else {
                Text(distance)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
    
    private var youCouldHelpSection: some View {
        let prompts = foodbank.donationPrompts

        return VStack(alignment: .leading, spacing: 10) {

            HStack(alignment: .firstTextBaseline) {
                Text("Add items to your next shop to help")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)

                Spacer()

                if !prompts.isEmpty {
                    Text("\(prompts.count)")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
            }

            if prompts.isEmpty {
                Text("No tailored suggestions right now.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 6)
            } else {
                ScrollView(.vertical, showsIndicators: true) {
                    VStack(spacing: 10) {
                        ForEach(prompts, id: \.id) { prompt in
                            HelpPromptRow(
                                title: "\(prompt.itemName) for \(prompt.needName)",
                                onAdd: { }
                            )
                        }
                    }
                    .padding(.vertical, 2)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                }
                .frame(maxHeight: 260)
                .scrollBounceBehavior(.basedOnSize)
            }
        }
    }

    // MARK: Needs Section

    private var needsSection: some View {
        VStack(alignment: .leading, spacing: 8) {

            Text("They need (\(foodbank.needs.count))")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)

            FlowLayoutView(spacing: 8) {
                ForEach(foodbank.needs.prefix(6)) { need in
                    PillView(text: need.name)
                }
            }
        }
    }

    // MARK: Surplus Section

    private var surplusSection: some View {
        VStack(alignment: .leading, spacing: 8) {

            Text("These items are not needed")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)

            FlowLayoutView(spacing: 8) {
                ForEach(foodbank.surpluses, id: \.self) { surplus in
                    PillView(text: surplus, color: .gray)
                }
            }
        }
    }
}

private struct HelpPromptRow: View {
    let title: String
    let onAdd: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 10) {

            Text(title)
                .font(.subheadline)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
                .layoutPriority(1)

            Spacer(minLength: 8)

            Button(action: onAdd) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(AppStyle.primary)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Add to shopping list")
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            .ultraThinMaterial,
            in: RoundedRectangle(cornerRadius: 18, style: .continuous)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(.white.opacity(0.10), lineWidth: 1)
        )
    }
}
