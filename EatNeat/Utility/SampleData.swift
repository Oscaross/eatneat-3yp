import Foundation

struct SampleData {
    static func generateSampleItems() -> [PantryItem] {
        return [

            // Cereals
            PantryItem(name: "Corn Flakes", category: .cerealsAndBreakfast, quantity: 1,
                       weightQuantity: 500, weightUnit: .grams, isPerishable: false),
            PantryItem(name: "Porridge Oats", category: .cerealsAndBreakfast, quantity: 1,
                       weightQuantity: 1000, weightUnit: .grams, isPerishable: false),

            PantryItem(name: "Tesco Corn Flakes 500g", category: .cerealsAndBreakfast, quantity: 1,
                       weightQuantity: 500, weightUnit: .grams, isPerishable: false),
            PantryItem(name: "Tesco Honey Nut Corn Flakes 500g", category: .cerealsAndBreakfast, quantity: 1,
                       weightQuantity: 500, weightUnit: .grams, isPerishable: false, imageURL: URL(string: "https://digitalcontent.api.tesco.com/v2/media/ghs/934ab7aa-01c7-4d8a-aa8a-03590e30db23/44888c13-6a84-4d6f-bafb-4fd95899bdf5_172205422.jpeg?h=960&w=960")),
            PantryItem(name: "Kellogg's Corn Flakes 500g", category: .cerealsAndBreakfast, quantity: 1,
                       weightQuantity: 500, weightUnit: .grams, isPerishable: false),

            // Pasta, Rice & Noodles
            PantryItem(name: "Spaghetti", category: .pastaRiceAndNoodles, quantity: 2,
                       weightQuantity: 500, weightUnit: .grams, isPerishable: false),
            PantryItem(name: "Basmati Rice", category: .pastaRiceAndNoodles, quantity: 1,
                       weightQuantity: 1000, weightUnit: .grams, isPerishable: false),
            PantryItem(name: "Couscous", category: .pastaRiceAndNoodles, quantity: 1,
                       weightQuantity: 500, weightUnit: .grams, isPerishable: false),
            PantryItem(name: "Instant Noodles (5 Pack)", category: .pastaRiceAndNoodles, quantity: 1,
                       weightQuantity: 375, weightUnit: .grams, isPerishable: false),

            PantryItem(name: "Tesco Basmati Rice 1kg", category: .pastaRiceAndNoodles, quantity: 1,
                       weightQuantity: 1000, weightUnit: .grams, isPerishable: false),
            PantryItem(name: "Tesco Long Grain Rice 1kg", category: .pastaRiceAndNoodles, quantity: 1,
                       weightQuantity: 1000, weightUnit: .grams, isPerishable: false),
            PantryItem(name: "Tesco Wholewheat Fusilli 500g", category: .pastaRiceAndNoodles, quantity: 1,
                       weightQuantity: 500, weightUnit: .grams, isPerishable: false),
            PantryItem(name: "Microwave Long Grain Rice 250g", category: .pastaRiceAndNoodles, quantity: 2,
                       weightQuantity: 250, weightUnit: .grams, isPerishable: false),

            // Tins, Cans & Packets
            PantryItem(name: "Chopped Tomatoes (Tinned)", category: .tinsCansAndPackets, quantity: 3,
                       weightQuantity: 400, weightUnit: .grams, isPerishable: false),
            PantryItem(name: "Baked Beans", category: .tinsCansAndPackets, quantity: 2,
                       weightQuantity: 415, weightUnit: .grams, isPerishable: false),
            PantryItem(name: "Sweetcorn (Tinned)", category: .tinsCansAndPackets, quantity: 1,
                       weightQuantity: 325, weightUnit: .grams, isPerishable: false),
            PantryItem(name: "Peaches in Juice (Tinned)", category: .tinsCansAndPackets, quantity: 1,
                       weightQuantity: 400, weightUnit: .grams, isPerishable: false),
            PantryItem(name: "Red Kidney Beans", category: .tinsCansAndPackets, quantity: 2,
                       weightQuantity: 400, weightUnit: .grams, isPerishable: false),
            PantryItem(name: "Tuna Chunks (4 Pack)", category: .tinsCansAndPackets, quantity: 4,
                       weightQuantity: 145, weightUnit: .grams, isPerishable: false),
            PantryItem(name: "Tomato Soup", category: .tinsCansAndPackets, quantity: 2,
                       weightQuantity: 400, weightUnit: .grams, isPerishable: false),
            PantryItem(name: "Tea Bags (80)", category: .tinsCansAndPackets, quantity: 1,
                       weightQuantity: 250, weightUnit: .grams, isPerishable: false),

            PantryItem(name: "Tesco Italian Chopped Tomatoes 400g", category: .tinsCansAndPackets, quantity: 3,
                       weightQuantity: 400, weightUnit: .grams, isPerishable: false),
            PantryItem(name: "Tesco Italian Finely Chopped Tomatoes 400g", category: .tinsCansAndPackets, quantity: 2,
                       weightQuantity: 400, weightUnit: .grams, isPerishable: false),
            PantryItem(name: "Heinz Baked Beans In Tomato Sauce 415g", category: .tinsCansAndPackets, quantity: 2,
                       weightQuantity: 415, weightUnit: .grams, isPerishable: false),
            PantryItem(name: "Tesco Baked Beans In Tomato Sauce 410g", category: .tinsCansAndPackets, quantity: 2,
                       weightQuantity: 410, weightUnit: .grams, isPerishable: false),
            PantryItem(name: "Tesco Sweetcorn In Water 325g", category: .tinsCansAndPackets, quantity: 2,
                       weightQuantity: 325, weightUnit: .grams, isPerishable: false),
            PantryItem(name: "Mutti Finely Chopped Tomatoes (4x400g)", category: .tinsCansAndPackets, quantity: 4,
                       weightQuantity: 400, weightUnit: .grams, isPerishable: false),

            // Home baking
            PantryItem(name: "Plain Flour", category: .homeBaking, quantity: 1,
                       weightQuantity: 1000, weightUnit: .grams, isPerishable: false),
            PantryItem(name: "Self-Raising Flour", category: .homeBaking, quantity: 1,
                       weightQuantity: 1000, weightUnit: .grams, isPerishable: false),
            PantryItem(name: "Caster Sugar", category: .homeBaking, quantity: 1,
                       weightQuantity: 1000, weightUnit: .grams, isPerishable: false),
            PantryItem(name: "Baking Powder", category: .homeBaking, quantity: 1,
                       weightQuantity: 200, weightUnit: .grams, isPerishable: false),
            PantryItem(name: "Chocolate Chips", category: .homeBaking, quantity: 1,
                       weightQuantity: 200, weightUnit: .grams, isPerishable: false),

            PantryItem(name: "Tesco Plain Flour 1kg", category: .homeBaking, quantity: 1,
                       weightQuantity: 1000, weightUnit: .grams, isPerishable: false),
            PantryItem(name: "Tesco Self Raising Flour 1kg", category: .homeBaking, quantity: 1,
                       weightQuantity: 1000, weightUnit: .grams, isPerishable: false),
            PantryItem(name: "Tesco Caster Sugar 1kg", category: .homeBaking, quantity: 1,
                       weightQuantity: 1000, weightUnit: .grams, isPerishable: false),

            // Cooking ingredients / sauces
            PantryItem(name: "Sunflower Oil", category: .cookingIngredients, quantity: 1,
                       weightQuantity: 1000, weightUnit: .millilitres, isPerishable: false),
            PantryItem(name: "Vegetable Stock Cubes (12)", category: .cookingIngredients, quantity: 1,
                       weightQuantity: 100, weightUnit: .grams, isPerishable: false),
            PantryItem(name: "Long-Grain Rice", category: .pastaRiceAndNoodles, quantity: 1,
                       weightQuantity: 500, weightUnit: .grams, isPerishable: false),

            PantryItem(name: "Olive Oil 500ml", category: .cookingIngredients, quantity: 1,
                       weightQuantity: 500, weightUnit: .millilitres, isPerishable: false),
            PantryItem(name: "Tesco Vegetable Oil 1L", category: .cookingIngredients, quantity: 1,
                       weightQuantity: 1000, weightUnit: .millilitres, isPerishable: false),
            PantryItem(name: "Lea & Perrins Worcestershire Sauce 290ml", category: .spreadsSaucesAndCondiments, quantity: 1,
                       weightQuantity: 290, weightUnit: .millilitres, isPerishable: false),
            PantryItem(name: "Soy Sauce 150ml", category: .spreadsSaucesAndCondiments, quantity: 1,
                       weightQuantity: 150, weightUnit: .millilitres, isPerishable: false),

            // Spreads & snacks
            PantryItem(name: "Strawberry Jam", category: .spreadsSaucesAndCondiments, quantity: 1,
                       weightQuantity: 340, weightUnit: .grams, isPerishable: false),
            PantryItem(name: "Peanut Butter (Smooth)", category: .spreadsSaucesAndCondiments, quantity: 1,
                       weightQuantity: 350, weightUnit: .grams, isPerishable: false),
            PantryItem(name: "Tomato Ketchup", category: .spreadsSaucesAndCondiments, quantity: 1,
                       weightQuantity: 460, weightUnit: .grams, isPerishable: false),
            PantryItem(name: "Mayonnaise", category: .spreadsSaucesAndCondiments, quantity: 1,
                       weightQuantity: 500, weightUnit: .grams, isPerishable: false),

            // Biscuits & snacks
            PantryItem(name: "Digestive Biscuits", category: .biscuitsSnacksAndConfectionery, quantity: 2,
                       weightQuantity: 300, weightUnit: .grams, isPerishable: false),
            PantryItem(name: "Cereal Bars (6 Pack)", category: .biscuitsSnacksAndConfectionery, quantity: 1,
                       weightQuantity: 180, weightUnit: .grams, isPerishable: false),
            PantryItem(name: "Dark Chocolate Bar", category: .biscuitsSnacksAndConfectionery, quantity: 1,
                       weightQuantity: 100, weightUnit: .grams, isPerishable: false),
            PantryItem(name: "Ready Salted Crisps (6 Pack)", category: .biscuitsSnacksAndConfectionery, quantity: 1,
                       weightQuantity: 150, weightUnit: .grams, isPerishable: false),

            // Toiletries / household / pet food
            PantryItem(name: "Shampoo", category: .hairCare, quantity: 1,
                       weightQuantity: 400, weightUnit: .millilitres, isPerishable: false),
            PantryItem(name: "Dog Dry Food", category: .petFoodAndSupplies, quantity: 1,
                       weightQuantity: 2000, weightUnit: .grams, isPerishable: false)
        ]
    }
    
    static func generateSampleLabels() -> [ItemLabel] {
        return [
            ItemLabel(name: "New", color: .green),
            ItemLabel(name: "Use", color: .blue),
            ItemLabel(name: "Half", color: .purple),
            ItemLabel(name: "Stale", color: .red),
            ItemLabel(name: "Going Off", color: .teal),
            ItemLabel(name: "Xmas", color: .orange)
            ]
    }
}
