//
//  DonationViewModel.swift
//  EatNeat
//
//  Created by Oscar Horner on 02/11/2025.
//
// Persistent state that manages donation related information and communication with MCP tool to map items to needs.

import SwiftUI

@MainActor
final class DonationViewModel: ObservableObject {
    @Published var foodbanks: [String: FoodbankNeeds] = [:] // maps foodbank IDs to their needs object
    @Published var shouldRender: Bool = false // whether the data is ready for the front-end to render it
    @EnvironmentObject var pantryViewModel: PantryViewModel

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
    
    /// Triggers a conversation with LLM agent to map pantry items to foodbank needs. Happens asynchronously and after foodbank metadata is loaded.
    func triggerMapping() async {
        // TODO: LLM interaction will be implemented once base STDIO functionality is proven
        print("Triggering LLM mapping of pantry items to foodbank needs...")
        shouldRender = true
    }
    
    func matchItemToNeed(foodbankID: String, needID: Int, itemID: UUID) {
        // Check that foodbank exists & item exists from ID. If either lookup fails, exit the call
        guard var foodbank = foodbanks[foodbankID] else {
            return
        }

        guard let item = pantryViewModel.getItemByID(itemID: itemID) else {
            return
        }

        // Perform the match
        foodbank.registerMatch(needId: needID, item: item)

        // Update to mutated struct with new match
        foodbanks[foodbankID] = foodbank
    }
    
    /// Converts input to a dictionary and filters invalid foodbanks.
    func filterFoodbanks(foodbanks: [FoodbankNeeds]) -> [String: FoodbankNeeds] {
        
        // Filter out invalid ones
        let validFoodbanks = foodbanks.filter { fb in
            // Needs must not be empty
            guard !fb.needsList.isEmpty else { return false }

            // Exclude Unknown
            let hasUnknown = fb.needsList.contains { need in
                need.name.localizedCaseInsensitiveContains("unknown")
            }

            return !hasUnknown
        }

        // Convert to a dictionary keyed by unique ID
        var dict: [String: FoodbankNeeds] = [:]

        for fb in validFoodbanks {
            dict[fb.id] = fb
        }

        return dict
    }

}
