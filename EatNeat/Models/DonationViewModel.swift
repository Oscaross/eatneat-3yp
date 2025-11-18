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
            self.foodbanks = filterFoodbanks(foodbanks: result)
        } catch {
            print("Failed to load foodbanks: \(error)")
        }
    }
    
    /// Removes redundant foodbanks such as ones with unknown needs.
    func filterFoodbanks(foodbanks: [FoodbankNeeds]) -> [FoodbankNeeds] {
        return foodbanks.filter { foodbank in
            guard let needs = foodbank.needs else {
                return false // exclude if nil
            }
            return !needs.contains("Unknown") // exclude "Unknown" entries
        }
    }

}
