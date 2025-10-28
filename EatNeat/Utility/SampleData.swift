//
//  SampleData.swift
//  EatNeat
//
//  Created by Oscar Horner on 18/10/2025.
//

struct SampleData {
    static func generateSampleItems() -> [PantryItem] {
        return [
            PantryItem(quantity: 1, weight: 1000, name: "Basmati Rice", category: .grainsAndPasta),
            PantryItem(quantity: 2, weight: 500, name: "Spaghetti", category: .grainsAndPasta),
            PantryItem(quantity: 3, weight: 400, name: "Canned Chopped Tomatoes", category: .cannedAndJarred),
            PantryItem(quantity: 4, weight: 415, name: "Baked Beans", category: .cannedAndJarred),
            PantryItem(quantity: 1, weight: 1000, name: "Plain Flour", category: .bakingIngredients),
            PantryItem(quantity: 1, weight: 500, name: "Caster Sugar", category: .bakingIngredients),
            PantryItem(quantity: 1, weight: 750, name: "Olive Oil", category: .oilsVinegarsAndCondiments),
            PantryItem(quantity: 2, weight: 150, name: "Soy Sauce", category: .oilsVinegarsAndCondiments),
            PantryItem(quantity: 1, weight: 50, name: "Mixed Herbs", category: .spicesAndSeasonings),
            PantryItem(quantity: 1, weight: 50, name: "Ground Black Pepper", category: .spicesAndSeasonings),
            PantryItem(quantity: 2, weight: 200, name: "Digestive Biscuits", category: .snacksAndConfectionery),
            PantryItem(quantity: 1, weight: 300, name: "Muesli", category: .cerealsAndBreakfast),
            PantryItem(quantity: 1, weight: 1000, name: "Semi-Skimmed Milk", category: .dairyAndAlternatives),
            PantryItem(quantity: 1, weight: 250, name: "Cheddar Cheese", category: .dairyAndAlternatives),
            PantryItem(quantity: 6, name: "Free-Range Eggs", category: .eggs),
            PantryItem(quantity: 1, weight: 500, name: "Apples", category: .freshProduce),
            PantryItem(quantity: 1, weight: 600, name: "Chicken Breast", category: .meatAndPoultry),
            PantryItem(quantity: 1, weight: 300, name: "Salmon Fillets", category: .seafood),
            PantryItem(quantity: 1, weight: 400, name: "Wholemeal Bread", category: .breadAndBakery),
            PantryItem(quantity: 1, weight: 350, name: "Peanut Butter", category: .saucesAndSpreads),
            PantryItem(quantity: 2, weight: 500, name: "Brown Rice", category: .grainsAndPasta),
            PantryItem(quantity: 2, weight: 400, name: "White Rice", category: .grainsAndPasta)
        ]
    }
}

