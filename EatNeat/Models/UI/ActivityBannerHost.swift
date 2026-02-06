//
//  ActivityBannerHost.swift
//  EatNeat
//
//  Created by Oscar Horner on 03/02/2026.
//
// Controller object for an ActivityBanner displayed within a view

import SwiftUI

struct ActivityBannerHost: ViewModifier {
    @Binding var banner: ActivityBanner?
    let duration: TimeInterval

    @State private var dismissTask: Task<Void, Never>?

    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content

            if let banner {
                ActivityBannerView(banner: banner)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .onAppear {
                        dismissTask?.cancel()
                        dismissTask = Task {
                            try? await Task.sleep(for: .seconds(duration))
                            await MainActor.run {
                                withAnimation {
                                    self.banner = nil
                                }
                            }
                        }
                    }
            }
        }
        .animation(.easeOut(duration: 0.25), value: banner)
    }
}

extension View {
    func activityBanner(
        _ banner: Binding<ActivityBanner?>,
        duration: TimeInterval = 3
    ) -> some View {
        modifier(ActivityBannerHost(banner: banner, duration: duration))
    }
}
