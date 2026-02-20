//
//  FilterButtonView.swift
//  EatNeat
//
//  Created by Oscar Horner on 12/02/2026.
//
// A generic view to render a "Filter by" button which prompts the user to select their specific item filtering criteria.

import SwiftUI

struct FilterButtonView: View {
    let action: () -> Void
    let filter: PantryFilterSet

    var body: some View {
        CapsuleView(
            content: .textAndIcon(
                text: "Filter \(filter.count() == 0 ? "" : "(\(filter.count()))")", // poor code readability is a price we pay for good user readability
                systemName: "line.3.horizontal.decrease.circle"
            ),
            color: AppStyle.primary,
            heavy: false,
            action: action
        )
    }
}

