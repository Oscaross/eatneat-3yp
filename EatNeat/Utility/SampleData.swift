//
//  SampleData.swift
//  EatNeat
//
//  Created by Oscar Horner on 18/10/2025.
//

struct SampleData {
    static func generateSampleItems() -> [PantryItem] {
        return [
            PantryItem(quantity: 1, weight: 500, name: "Corn Flakes", category: .cerealsAndBreakfast),
            PantryItem(quantity: 1, weight: 1000, name: "Porridge Oats", category: .cerealsAndBreakfast),
            PantryItem(quantity: 2, weight: 500, name: "Spaghetti", category: .pastaRiceAndNoodles),
            PantryItem(quantity: 1, weight: 1000, name: "Basmati Rice", category: .pastaRiceAndNoodles),
            PantryItem(quantity: 1, weight: 500, name: "Couscous", category: .pastaRiceAndNoodles),
            PantryItem(quantity: 1, weight: 375, name: "Instant Noodles (5 Pack)", category: .pastaRiceAndNoodles),

            PantryItem(quantity: 3, weight: 400, name: "Chopped Tomatoes (Tinned)", category: .tinsCansAndPackets),
            PantryItem(quantity: 2, weight: 415, name: "Baked Beans", category: .tinsCansAndPackets),
            PantryItem(quantity: 1, weight: 325, name: "Sweetcorn (Tinned)", category: .tinsCansAndPackets),
            PantryItem(quantity: 1, weight: 400, name: "Peaches in Juice (Tinned)", category: .tinsCansAndPackets),
            PantryItem(quantity: 2, weight: 400, name: "Red Kidney Beans", category: .tinsCansAndPackets),
            PantryItem(quantity: 4, weight: 145, name: "Tuna Chunks (4 Pack)", category: .tinsCansAndPackets),
            PantryItem(quantity: 2, weight: 400, name: "Tomato Soup", category: .tinsCansAndPackets),
            PantryItem(quantity: 1, weight: 250, name: "Tea Bags (80)", category: .tinsCansAndPackets),

            PantryItem(quantity: 1, weight: 1000, name: "Plain Flour", category: .homeBaking),
            PantryItem(quantity: 1, weight: 1000, name: "Self-Raising Flour", category: .homeBaking),
            PantryItem(quantity: 1, weight: 1000, name: "Caster Sugar", category: .homeBaking),
            PantryItem(quantity: 1, weight: 200, name: "Baking Powder", category: .homeBaking),
            PantryItem(quantity: 1, weight: 200, name: "Chocolate Chips", category: .homeBaking),

            PantryItem(quantity: 1, weight: 1000, name: "Sunflower Oil", category: .cookingIngredients),
            PantryItem(quantity: 1, weight: 100, name: "Vegetable Stock Cubes (12)", category: .cookingIngredients),
            PantryItem(quantity: 1, weight: 500, name: "Long-Grain Rice", category: .pastaRiceAndNoodles),

            PantryItem(quantity: 1, weight: 340, name: "Strawberry Jam", category: .spreadsSaucesAndCondiments),
            PantryItem(quantity: 1, weight: 350, name: "Peanut Butter (Smooth)", category: .spreadsSaucesAndCondiments),
            PantryItem(quantity: 1, weight: 460, name: "Tomato Ketchup", category: .spreadsSaucesAndCondiments),
            PantryItem(quantity: 1, weight: 500, name: "Mayonnaise", category: .spreadsSaucesAndCondiments),

            PantryItem(quantity: 2, weight: 300, name: "Digestive Biscuits", category: .biscuitsSnacksAndConfectionery),
            PantryItem(quantity: 1, weight: 180, name: "Cereal Bars (6 Pack)", category: .biscuitsSnacksAndConfectionery),
            PantryItem(quantity: 1, weight: 100, name: "Dark Chocolate Bar", category: .biscuitsSnacksAndConfectionery),
            PantryItem(quantity: 1, weight: 150, name: "Ready Salted Crisps (6 Pack)", category: .biscuitsSnacksAndConfectionery),

            
            PantryItem(quantity: 1, weight: 400, name: "Shampoo", category: .hairCare),
            PantryItem(quantity: 1, weight: 400, name: "Conditioner", category: .hairCare),
            PantryItem(quantity: 1, weight: 500, name: "Body Wash", category: .bodyAndSkincare),
            PantryItem(quantity: 1, weight: 150, name: "Deodorant Spray", category: .bodyAndSkincare),
            PantryItem(quantity: 1, weight: 100, name: "Toothpaste", category: .dentalCare),
            PantryItem(quantity: 1, name: "Toothbrushes (2 Pack)", category: .dentalCare),
            PantryItem(quantity: 1, weight: 200, name: "Shaving Gel", category: .shavingAndGrooming),
            PantryItem(quantity: 1, name: "Disposable Razors (5 Pack)", category: .shavingAndGrooming),
            PantryItem(quantity: 1, name: "Sanitary Pads (12 Pack)", category: .sanitaryAndBabyCare),
            PantryItem(quantity: 1, name: "Baby Wipes (64)", category: .sanitaryAndBabyCare),

            
            PantryItem(quantity: 1, name: "Laundry Tablets (20 Washes)", category: .laundryAndFabricCare),
            PantryItem(quantity: 1, weight: 1000, name: "Fabric Softener", category: .laundryAndFabricCare),
            PantryItem(quantity: 1, name: "Toilet Roll (9 Pack)", category: .householdEssentials),
            PantryItem(quantity: 1, name: "Kitchen Roll (2 Pack)", category: .householdEssentials),
            PantryItem(quantity: 1, name: "Bin Bags (20)", category: .householdEssentials),
            PantryItem(quantity: 1, name: "Lightbulbs (2 Pack)", category: .householdEssentials),

            PantryItem(quantity: 1, weight: 2000, name: "Dog Dry Food", category: .petFoodAndSupplies),
            PantryItem(quantity: 1, name: "Cat Food Pouches (12x85g)", category: .petFoodAndSupplies)
        ]
    }
}

