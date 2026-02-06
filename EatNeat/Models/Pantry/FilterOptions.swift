//
//  FilterOptions.swift
//  EatNeat
//
//  Created by Oscar Horner on 04/02/2026.
//
// Represents the set of filtering criteria that a user can apply when viewing a list of items in their pantry.

import Foundation

struct FilterOptions: Identifiable {
    let id = UUID()
    
    var categorySet: Set<Category>? // categories the items belong to
    var labelSet: Set<ItemLabel>? // items must have at least one of these labels
    
    var isPerishable: Bool? // whether the items are perishable or not
    var isOpened: Bool? // whether the items are opened or unopened
    
    var minQuantity: Int? // minimum quantity of the items
    var maxQuantity: Int? // maximum quantity of the items
    
    var durationInPantry: TimeInterval?
    var durationBeforeExpiry: TimeInterval?
}

extension FilterOptions {

    /// Returns true if the given item satisfies all active filter constraints.
    func matches(_ item: PantryItem, now: Date = .now) -> Bool {

        // Category filter
        if let categorySet, !categorySet.isEmpty {
            if !categorySet.contains(item.category) {
                return false
            }
        }

        // Label filter (must have at least one matching label)
        if let labelSet, !labelSet.isEmpty {
            let itemLabels = Set(item.labels)
            if itemLabels.isDisjoint(with: labelSet) {
                return false
            }
        }

        // Perishable / opened flags
        if let isPerishable, item.isPerishable != isPerishable {
            return false
        }

        if let isOpened, item.isOpened != isOpened {
            return false
        }

        // Quantity bounds
        if let minQuantity, item.quantity < minQuantity {
            return false
        }

        if let maxQuantity, item.quantity > maxQuantity {
            return false
        }

        // Duration in pantry (time since added)
        if let durationInPantry {
            let timeInPantry = now.timeIntervalSince(item.dateAdded)
            if timeInPantry < durationInPantry {
                return false
            }
        }

        // Duration before expiry (time remaining)
        if let durationBeforeExpiry {
            guard let expiry = item.expiry else {
                return false // cannot satisfy expiry-based filters
            }

            let timeRemaining = expiry.timeIntervalSince(now)
            if timeRemaining > durationBeforeExpiry {
                return false
            }
        }

        return true
    }
}
