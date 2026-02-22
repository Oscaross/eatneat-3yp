//
//  Category.swift
//  EatNeat
//
//  Created by Oscar Horner on 23/09/2025.
//

enum Category: String, CaseIterable, Identifiable, Codable {
    var id: String { rawValue }
    
    case fruitAndVegetables = "Fruit & Vegetables"
    case dairy = "Dairy"
    case meat = "Meat"
    case chilled = "Chilled"
    case breakfast = "Breakfast"
    case tinsAndCans = "Tins & Cans"
    case grainsAndBakery = "Grains & Bakery"
    case cookingIngredients = "Cooking Ingredients"
    case snacksAndConfectionery = "Snacks & Confectionery"
    case spreadsAndCondiments = "Spreads & Condiments"
    case beverages = "Beverages"
    case frozen = "Frozen"
    case homeBaking = "Home Baking"

    // Household
    case toiletries = "Toiletries"
    case householdEssentials = "Household Essentials"
    case babySupplies = "Baby Supplies"
    case petSupplies = "Pet Supplies"

    case uncategorised = "Uncategorised"
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
