//
//  Category.swift
//  EatNeat
//
//  Created by Oscar Horner on 23/09/2025.
//

enum Category: String, CaseIterable, Identifiable, Codable {
    var id: String { rawValue }

    // Food & Drink
    case cerealsAndBreakfast = "Cereals & Breakfast"
    case tinsCansAndPackets = "Tins, Cans & Packets"
    case pastaRiceAndNoodles = "Pasta, Rice & Noodles"
    case cookingIngredients = "Cooking Ingredients"
    case biscuitsSnacksAndConfectionery = "Biscuits, Snacks & Confectionery"
    case spreadsSaucesAndCondiments = "Spreads, Sauces & Condiments"
    case homeBaking = "Home Baking"

    // Toiletries & Personal Care
    case hairCare = "Hair Care"
    case bodyAndSkincare = "Body & Skincare"
    case dentalCare = "Dental Care"
    case shavingAndGrooming = "Shaving & Grooming"
    case sanitaryAndBabyCare = "Sanitary & Baby Care"

    // Household & Cleaning
    case laundryAndFabricCare = "Laundry & Fabric Care"
    case householdEssentials = "Household Essentials"
    case petFoodAndSupplies = "Pet Food & Supplies"

    case none = "None"
}

extension Category {

    static let orderedCases = allCases

    var index: Int {
        Self.orderedCases.firstIndex(of: self)!
    }

    static func from(index: Int) -> Category? {
        orderedCases.indices.contains(index) ? orderedCases[index] : nil
    }
}
