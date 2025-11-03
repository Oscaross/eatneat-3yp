//
//  DonationViewModel.swift
//  EatNeat
//
//  Created by Oscar Horner on 02/11/2025.
//

import SwiftUI

@MainActor
final class DonationViewModel: ObservableObject {
    @Published var foodbanks: [FoodbankNeeds] = []

    private let api: LocalFoodbankAPI

    init(locationManager: LocationManager) {
        self.api = LocalFoodbankAPI(locationManager: locationManager)
    }

    func loadFoodbanks() async {
        do {
            let result = try await api.pollFoodbankNeeds()
            self.foodbanks = result
        } catch {
            print("Failed to load foodbanks: \(error)")
        }
    }
}
