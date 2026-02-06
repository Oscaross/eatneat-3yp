//
//  ActivityBannerView.swift
//  EatNeat
//
//  Created by Oscar Horner on 03/02/2026.
//
// Represents the UI code for an activity banner as described by ActivityBanner.swift

import SwiftUI

struct ActivityBannerView: View {
    let banner: ActivityBanner

    var body: some View {
        HStack(spacing: 12) {
            Text(banner.message)
                .font(.subheadline)
                .foregroundStyle(.primary)
                .lineLimit(2)

            Spacer()

            if let title = banner.actionTitle,
               let action = banner.action {
                Button(title) {
                    action()
                }
                .font(.subheadline.weight(.semibold))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(radius: 6, y: 2)
        .padding(.horizontal)
    }
}
