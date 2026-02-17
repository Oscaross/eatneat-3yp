//
//  PillView.swift
//  EatNeat
//
//  Created by Oscar Horner on 14/02/2026.
//
// Represents a pill type view structure that is used in the app frequently in places such as category picking, filtering and needs filtering.

import SwiftUI

struct PillView: View {

    let text: String
    var color: Color = AppStyle.accentBlue
    var isSelected: Bool = false
    var font: Font = .system(size: 13, weight: .semibold)
    var onTap: (() -> Void)? = nil

    var body: some View {
        Button {
            onTap?()
        } label: {
            Text(text)
                .font(font)
                .lineLimit(1)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .foregroundColor(isSelected ? .white : color)
                .background(
                    Capsule()
                        .fill(isSelected ? color : Color.clear)
                )
                .overlay(
                    Capsule()
                        .stroke(color, lineWidth: 1.4)
                )
        }
        .buttonStyle(.plain)
    }
}
