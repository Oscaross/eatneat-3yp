//
//  BannerManager.swift
//  EatNeat
//
//  Created by Oscar Horner on 03/02/2026.
//
// Controller object that handles the lifecycle for an ActivityBanner displayed within a view

import SwiftUI

@MainActor
final class BannerManager: ObservableObject {

    @Published var banner: ActivityBanner?

    private var dismissTask: Task<Void, Never>?

    func dismiss() {
        dismissTask?.cancel()
        dismissTask = nil
        banner = nil
    }

    func spawn(_ event: BannerEvent, autoDismissAfter seconds: Double? = AppConstants.BANNER_TIMEOUT_SECONDS) {
        dismissTask?.cancel()
        dismissTask = nil

        let newBanner: ActivityBanner
        switch event {
        case let .removedItem(name, undo):
            newBanner = ActivityBanner(
                message: "Deleted \(name) from pantry",
                actionTitle: "Undo",
                action: undo
            )
        case let .generic(message):
            newBanner = ActivityBanner(message: message, actionTitle: nil, action: nil)
        }

        banner = newBanner

        guard let seconds else { return }
        // wait for autoDismissAfter seconds and then dismiss automatically
        let bannerID = newBanner.id
        dismissTask = Task { [weak self] in
            try? await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
            await MainActor.run {
                // Only dismiss if it's still the same banner
                if self?.banner?.id == bannerID {
                    self?.banner = nil
                }
            }
        }
    }
}

/// Something that happened that triggers a banner to spawn such as removing an item and the associated data coupled with that event.
enum BannerEvent {
    case removedItem(name: String, undo: () -> Void)
    case generic(message: String)
}
