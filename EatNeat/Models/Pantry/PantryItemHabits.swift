//
//  PantryItemHabits.swift
//  EatNeat
//
//  Created by Oscar Horner on 27/02/2026.
//
// Data model that stores information related to the users consumption and purchase habits of a particular item name. The PantryViewModel stores a map of this information keyed by all unique items that the user has added to their pantry.

import Foundation

struct PantryItemHabits {
    var totalPurchases: Int
    var firstPurchasedAt: Date?
    var lastPurchasedAt: Date?

    /// Exponentially weighted purchase rate
    var emaPurchaseRate: Double

    /// When emaPurchaseRate was last updated
    var lastRateUpdate: Date?

    /// If the user manually told us this is a regular item they use
    var manuallyFavourited: Bool
}
