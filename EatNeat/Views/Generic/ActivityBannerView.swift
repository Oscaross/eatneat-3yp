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
        HStack {
            Text(banner.message)
                .font(.subheadline)

            Spacer()

            if let actionTitle = banner.actionTitle,
               let action = banner.action {
                Button(actionTitle) {
                    action()
                }
                .fontWeight(.semibold)
            }
        }
        .padding()
        .background(.ultraThinMaterial.opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(radius: 8)
    }
}

struct ActivityBannerModifier: ViewModifier {
    @Binding var banner: ActivityBanner?

    func body(content: Content) -> some View {
        ZStack {
            content

            if let banner {
                VStack {
                    Spacer()

                    ActivityBannerView(banner: banner)
                        .padding(.horizontal)
                        .padding(.bottom, 24)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                .animation(.spring(response: 0.35, dampingFraction: 0.85), value: banner != nil)
            }
        }
    }
}

/// Allows us to append .activityBanner() to the root of a view and spawn it
extension View {
    func activityBanner(_ banner: Binding<ActivityBanner?>) -> some View {
        modifier(ActivityBannerModifier(banner: banner))
    }
}
