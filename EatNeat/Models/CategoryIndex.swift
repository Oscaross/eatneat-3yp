//
//  CategoryIndex.swift
//  EatNeat
//
//  Created by Oscar Horner on 26/01/2026.
//
// Represents a mapping between Category enum cases and their corresponding indices. Allows consistency within the app for custom and global category labels.

import Foundation

struct CategoryIndex {
    static let mapping: [Category: Int] = [
        .cerealsAndBreakfast: 0,
        .tinsCansAndPackets: 1,
        .pastaRiceAndNoodles: 2,
        .cookingIngredients: 3,
        .biscuitsSnacksAndConfectionery: 4,
        .spreadsSaucesAndCondiments: 5,
        .homeBaking: 6,

        .hairCare: 7,
        .bodyAndSkincare: 8,
        .dentalCare: 9,
        .shavingAndGrooming: 10,
        .sanitaryAndBabyCare: 11,

        .laundryAndFabricCare: 12,
        .householdEssentials: 13,
        .petFoodAndSupplies: 14,

        .none: 15
    ]

    static let reverse: [Int: Category] = {
        Dictionary(uniqueKeysWithValues: mapping.map { ($1, $0) })
    }()
}
