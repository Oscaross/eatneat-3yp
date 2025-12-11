//
//  SampleData.swift
//  EatNeat
//

struct SampleData {
    static func generateSampleItems() -> [PantryItem] {
        return [

            // Cereals
            PantryItem(name: "Corn Flakes", category: .cerealsAndBreakfast, quantity: 1,
                       weightQuantity: 500, weightUnit: .grams),
            PantryItem(name: "Porridge Oats", category: .cerealsAndBreakfast, quantity: 1,
                       weightQuantity: 1000, weightUnit: .grams),

            // Pasta, Rice & Noodles
            PantryItem(name: "Spaghetti", category: .pastaRiceAndNoodles, quantity: 2,
                       weightQuantity: 500, weightUnit: .grams),
            PantryItem(name: "Basmati Rice", category: .pastaRiceAndNoodles, quantity: 1,
                       weightQuantity: 1000, weightUnit: .grams),
            PantryItem(name: "Couscous", category: .pastaRiceAndNoodles, quantity: 1,
                       weightQuantity: 500, weightUnit: .grams),
            PantryItem(name: "Instant Noodles (5 Pack)", category: .pastaRiceAndNoodles, quantity: 1,
                       weightQuantity: 375, weightUnit: .grams),

            // Tins, Cans & Packets
            PantryItem(name: "Chopped Tomatoes (Tinned)", category: .tinsCansAndPackets, quantity: 3,
                       weightQuantity: 400, weightUnit: .grams),
            PantryItem(name: "Baked Beans", category: .tinsCansAndPackets, quantity: 2,
                       weightQuantity: 415, weightUnit: .grams),
            PantryItem(name: "Sweetcorn (Tinned)", category: .tinsCansAndPackets, quantity: 1,
                       weightQuantity: 325, weightUnit: .grams),
            PantryItem(name: "Peaches in Juice (Tinned)", category: .tinsCansAndPackets, quantity: 1,
                       weightQuantity: 400, weightUnit: .grams),
            PantryItem(name: "Red Kidney Beans", category: .tinsCansAndPackets, quantity: 2,
                       weightQuantity: 400, weightUnit: .grams),
            PantryItem(name: "Tuna Chunks (4 Pack)", category: .tinsCansAndPackets, quantity: 4,
                       weightQuantity: 145, weightUnit: .grams),
            PantryItem(name: "Tomato Soup", category: .tinsCansAndPackets, quantity: 2,
                       weightQuantity: 400, weightUnit: .grams),
            PantryItem(name: "Tea Bags (80)", category: .tinsCansAndPackets, quantity: 1,
                       weightQuantity: 250, weightUnit: .grams),

            // Home baking
            PantryItem(name: "Plain Flour", category: .homeBaking, quantity: 1,
                       weightQuantity: 1000, weightUnit: .grams),
            PantryItem(name: "Self-Raising Flour", category: .homeBaking, quantity: 1,
                       weightQuantity: 1000, weightUnit: .grams),
            PantryItem(name: "Caster Sugar", category: .homeBaking, quantity: 1,
                       weightQuantity: 1000, weightUnit: .grams),
            PantryItem(name: "Baking Powder", category: .homeBaking, quantity: 1,
                       weightQuantity: 200, weightUnit: .grams),
            PantryItem(name: "Chocolate Chips", category: .homeBaking, quantity: 1,
                       weightQuantity: 200, weightUnit: .grams),

            // Cooking ingredients
            PantryItem(name: "Sunflower Oil", category: .cookingIngredients, quantity: 1,
                       weightQuantity: 1000, weightUnit: .millilitres),
            PantryItem(name: "Vegetable Stock Cubes (12)", category: .cookingIngredients, quantity: 1,
                       weightQuantity: 100, weightUnit: .grams),
            PantryItem(name: "Long-Grain Rice", category: .pastaRiceAndNoodles, quantity: 1,
                       weightQuantity: 500, weightUnit: .grams),

            // Spreads & sauces
            PantryItem(name: "Strawberry Jam", category: .spreadsSaucesAndCondiments, quantity: 1,
                       weightQuantity: 340, weightUnit: .grams),
            PantryItem(name: "Peanut Butter (Smooth)", category: .spreadsSaucesAndCondiments, quantity: 1,
                       weightQuantity: 350, weightUnit: .grams),
            PantryItem(name: "Tomato Ketchup", category: .spreadsSaucesAndCondiments, quantity: 1,
                       weightQuantity: 460, weightUnit: .grams),
            PantryItem(name: "Mayonnaise", category: .spreadsSaucesAndCondiments, quantity: 1,
                       weightQuantity: 500, weightUnit: .grams),

            // Biscuits & snacks
            PantryItem(name: "Digestive Biscuits", category: .biscuitsSnacksAndConfectionery, quantity: 2,
                       weightQuantity: 300, weightUnit: .grams),
            PantryItem(name: "Cereal Bars (6 Pack)", category: .biscuitsSnacksAndConfectionery, quantity: 1,
                       weightQuantity: 180, weightUnit: .grams),
            PantryItem(name: "Dark Chocolate Bar", category: .biscuitsSnacksAndConfectionery, quantity: 1,
                       weightQuantity: 100, weightUnit: .grams),
            PantryItem(name: "Ready Salted Crisps (6 Pack)", category: .biscuitsSnacksAndConfectionery, quantity: 1,
                       weightQuantity: 150, weightUnit: .grams),

            // Toiletries (assume ml for liquids)
            PantryItem(name: "Shampoo", category: .hairCare, quantity: 1,
                       weightQuantity: 400, weightUnit: .millilitres),
            PantryItem(name: "Conditioner", category: .hairCare, quantity: 1,
                       weightQuantity: 400, weightUnit: .millilitres),
            PantryItem(name: "Body Wash", category: .bodyAndSkincare, quantity: 1,
                       weightQuantity: 500, weightUnit: .millilitres),
            PantryItem(name: "Deodorant Spray", category: .bodyAndSkincare, quantity: 1,
                       weightQuantity: 150, weightUnit: .millilitres),
            PantryItem(name: "Toothpaste", category: .dentalCare, quantity: 1,
                       weightQuantity: 100, weightUnit: .millilitres),

            // Items without weights
            PantryItem(name: "Toothbrushes (2 Pack)", category: .dentalCare, quantity: 1),
            PantryItem(name: "Disposable Razors (5 Pack)", category: .shavingAndGrooming, quantity: 1),
            PantryItem(name: "Sanitary Pads (12 Pack)", category: .sanitaryAndBabyCare, quantity: 1),
            PantryItem(name: "Baby Wipes (64)", category: .sanitaryAndBabyCare, quantity: 1),

            // Household
            PantryItem(name: "Laundry Tablets (20 Washes)", category: .laundryAndFabricCare, quantity: 1),
            PantryItem(name: "Fabric Softener", category: .laundryAndFabricCare, quantity: 1,
                       weightQuantity: 1000, weightUnit: .millilitres),
            PantryItem(name: "Toilet Roll (9 Pack)", category: .householdEssentials, quantity: 1),
            PantryItem(name: "Kitchen Roll (2 Pack)", category: .householdEssentials, quantity: 1),
            PantryItem(name: "Bin Bags (20)", category: .householdEssentials, quantity: 1),
            PantryItem(name: "Lightbulbs (2 Pack)", category: .householdEssentials, quantity: 1),

            // Pet food (kg for dry food)
            PantryItem(name: "Dog Dry Food", category: .petFoodAndSupplies, quantity: 1,
                       weightQuantity: 2000, weightUnit: .grams),

            PantryItem(name: "Cat Food Pouches (12x85g)", category: .petFoodAndSupplies, quantity: 1)
        ]
    }
    
    static func matchSampleItems() {
        
    }
}
