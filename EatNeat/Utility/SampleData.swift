// Author: ChatGPT
// Class to support testing, large amount of realistic looking test data and test values that simulate a real-world pantry.
// For future testing, we would get a user to actually use the pantry for 3 months or so, then we would take that snapshot as the test data.


import Foundation

struct SampleData {
    /// Large, realistic supermarket-style sample dataset (8 items per category).
    /// - ~30% unlabeled items
    /// - remaining items get 1–3 labels (mostly 1; fewer 2; rare 3)
    /// - labels are biased realistically (e.g., "Use Soon"/"Going Off" more likely on perishables/opened)
    static func generateSampleItems(labels: [ItemLabel]) -> [PantryItem] {

        // Fast label lookup by name
        let labelsByName: [String: ItemLabel] = Dictionary(uniqueKeysWithValues: labels.map { ($0.name, $0) })

        func l(_ names: [String]) -> [ItemLabel] {
            names.compactMap { labelsByName[$0] }
        }

        // Deterministic RNG for stable previews/tests
        struct SeededRNG: RandomNumberGenerator {
            private var state: UInt64
            init(seed: UInt64) { self.state = seed }
            mutating func next() -> UInt64 {
                // xorshift64*
                state &+= 0x9E3779B97F4A7C15
                var z = state
                z = (z ^ (z >> 30)) &* 0xBF58476D1CE4E5B9
                z = (z ^ (z >> 27)) &* 0x94D049BB133111EB
                return z ^ (z >> 31)
            }
        }

        var rng = SeededRNG(seed: 0xEAD2026)

        func chance(_ p: Double) -> Bool {
            Double.random(in: 0..<1, using: &rng) < p
        }

        func pick<T>(_ xs: [T]) -> T {
            xs[Int.random(in: 0..<xs.count, using: &rng)]
        }

        /// Realistic label assignment with a ~30% chance of no labels.
        /// Distribution for labeled items: mostly 1, fewer 2, rare 3.
        func assignLabels(isPerishable: Bool, isOpened: Bool, category: Category) -> [ItemLabel] {
            // ~30% none
            if chance(0.30) { return [] }

            // 1/2/3 labels
            let roll = Double.random(in: 0..<1, using: &rng)
            let count: Int = (roll < 0.80) ? 1 : (roll < 0.96) ? 2 : 3

            // Candidate labels (bias by perishability/opened)
            var pool: [String] = []

            // Freshness-related labels
            if isPerishable || isOpened {
                pool += ["Use Soon", "Going Off", "Stale"]
                // stronger bias if both
                if isPerishable && isOpened { pool += ["Use Soon", "Going Off"] }
            } else {
                // non-perishables can still be "Stale" (e.g., biscuits) or "Use Soon" (open packets)
                pool += ["Stale", "Use Soon"]
            }

            // Dietary labels: mostly food categories
            let isFood = category != .toiletries
                && category != .householdEssentials
                && category != .babySupplies
                && category != .petSupplies

            if isFood {
                // common enough on food
                pool += ["Vegan", "Gluten Free"]
                // more likely vegan on plant-heavy categories
                if category == .fruitAndVegetables || category == .tinsAndCans || category == .cookingIngredients || category == .frozen {
                    pool += ["Vegan"]
                }
            }

            // Occasion label is rare
            if chance(0.08) { pool += ["Birthday"] }

            // Pick unique labels
            var chosen: [String] = []
            while chosen.count < count && !pool.isEmpty {
                let candidate = pick(pool)
                if !chosen.contains(candidate) {
                    chosen.append(candidate)
                }
            }

            return l(chosen)
        }

        func make(
            _ name: String,
            _ category: Category,
            quantity: Int = 1,
            weightQuantity: Double? = nil,
            weightUnit: WeightUnit? = nil,
            isPerishable: Bool,
            isOpened: Bool
        ) -> PantryItem {

            PantryItem(
                name: name,
                category: category,
                quantity: quantity,
                weightQuantity: weightQuantity,
                weightUnit: weightUnit,
                isOpened: isOpened,
                isPerishable: isPerishable,
                labels: Set(assignLabels(isPerishable: isPerishable, isOpened: isOpened, category: category))
            )
        }

        var items: [PantryItem] = []

        // MARK: - Fruit & Vegetables (8)
        items += [
            make("Bananas", .fruitAndVegetables, weightQuantity: 1.0, weightUnit: .kilograms, isPerishable: true,  isOpened: false),
            make("Apples", .fruitAndVegetables, weightQuantity: 6,   weightUnit: WeightUnit.none,     isPerishable: true,  isOpened: false),
            make("Carrots", .fruitAndVegetables, weightQuantity: 1.0, weightUnit: .kilograms, isPerishable: true, isOpened: false),
            make("Broccoli", .fruitAndVegetables, weightQuantity: 350, weightUnit: .grams,   isPerishable: true,  isOpened: false),
            make("Cherry Tomatoes", .fruitAndVegetables, weightQuantity: 250, weightUnit: .grams, isPerishable: true, isOpened: true),
            make("Spinach", .fruitAndVegetables, weightQuantity: 200, weightUnit: .grams,   isPerishable: true,  isOpened: true),
            make("Onions", .fruitAndVegetables, weightQuantity: 1.0,  weightUnit: .kilograms, isPerishable: false, isOpened: false),
            make("Potatoes", .fruitAndVegetables, weightQuantity: 2.5, weightUnit: .kilograms, isPerishable: false, isOpened: false),
        ]

        // MARK: - Dairy (8)
        items += [
            make("Milk", .dairy, weightQuantity: 2.0, weightUnit: .litres, isPerishable: true,  isOpened: true),
            make("Butter", .dairy, weightQuantity: 250, weightUnit: .grams, isPerishable: true, isOpened: true),
            make("Cheddar Cheese", .dairy, weightQuantity: 400, weightUnit: .grams, isPerishable: true, isOpened: true),
            make("Greek Yogurt", .dairy, weightQuantity: 500, weightUnit: .grams, isPerishable: true, isOpened: false),
            make("Natural Yogurt", .dairy, weightQuantity: 500, weightUnit: .grams, isPerishable: true, isOpened: true),
            make("Eggs", .dairy, weightQuantity: 12, weightUnit: WeightUnit.none, isPerishable: true, isOpened: false),
            make("Cream", .dairy, weightQuantity: 300, weightUnit: .millilitres, isPerishable: true, isOpened: false),
            make("Mozzarella", .dairy, weightQuantity: 125, weightUnit: .grams, isPerishable: true, isOpened: false),
        ]

        // MARK: - Meat (8)
        items += [
            make("Chicken Breast Fillets", .meat, weightQuantity: 600, weightUnit: .grams, isPerishable: true, isOpened: false),
            make("Beef Mince", .meat, weightQuantity: 500, weightUnit: .grams, isPerishable: true, isOpened: false),
            make("Smoked Bacon", .meat, weightQuantity: 300, weightUnit: .grams, isPerishable: true, isOpened: true),
            make("Pork Sausages", .meat, weightQuantity: 8, weightUnit: WeightUnit.none, isPerishable: true, isOpened: false),
            make("Chicken Thighs", .meat, weightQuantity: 800, weightUnit: .grams, isPerishable: true, isOpened: false),
            make("Salami Slices", .meat, weightQuantity: 120, weightUnit: .grams, isPerishable: true, isOpened: true),
            make("Turkey Slices", .meat, weightQuantity: 150, weightUnit: .grams, isPerishable: true, isOpened: true),
            make("Beef Steak", .meat, weightQuantity: 2, weightUnit: WeightUnit.none, isPerishable: true, isOpened: false),
        ]

        // MARK: - Chilled (8)
        items += [
            make("Hummus", .chilled, weightQuantity: 200, weightUnit: .grams, isPerishable: true, isOpened: true),
            make("Fresh Pasta", .chilled, weightQuantity: 300, weightUnit: .grams, isPerishable: true, isOpened: false),
            make("Coleslaw", .chilled, weightQuantity: 300, weightUnit: .grams, isPerishable: true, isOpened: true),
            make("Pesto", .chilled, weightQuantity: 190, weightUnit: .grams, isPerishable: true, isOpened: true),
            make("Fresh Soup", .chilled, weightQuantity: 600, weightUnit: .grams, isPerishable: true, isOpened: false),
            make("Cooked Ham", .chilled, weightQuantity: 200, weightUnit: .grams, isPerishable: true, isOpened: true),
            make("Ready-to-Eat Salad", .chilled, weightQuantity: 220, weightUnit: .grams, isPerishable: true, isOpened: false),
            make("Fresh Salsa", .chilled, weightQuantity: 200, weightUnit: .grams, isPerishable: true, isOpened: true),
        ]

        // MARK: - Breakfast (8)
        items += [
            make("Corn Flakes", .breakfast, weightQuantity: 500, weightUnit: .grams, isPerishable: false, isOpened: true),
            make("Porridge Oats", .breakfast, weightQuantity: 1.0, weightUnit: .kilograms, isPerishable: false, isOpened: false),
            make("Granola", .breakfast, weightQuantity: 500, weightUnit: .grams, isPerishable: false, isOpened: true),
            make("Muesli", .breakfast, weightQuantity: 750, weightUnit: .grams, isPerishable: false, isOpened: false),
            make("Pancake Mix", .breakfast, weightQuantity: 155, weightUnit: .grams, isPerishable: false, isOpened: false),
            make("Maple Syrup", .breakfast, weightQuantity: 250, weightUnit: .millilitres, isPerishable: false, isOpened: true),
            make("Breakfast Bars", .breakfast, weightQuantity: 6, weightUnit: WeightUnit.none, isPerishable: false, isOpened: false),
            make("Rice Cakes", .breakfast, weightQuantity: 100, weightUnit: .grams, isPerishable: false, isOpened: true),
        ]

        // MARK: - Tins & Cans (8)
        items += [
            make("Baked Beans", .tinsAndCans, quantity: 3, weightQuantity: 415, weightUnit: .grams, isPerishable: false, isOpened: false),
            make("Chopped Tomatoes", .tinsAndCans, quantity: 4, weightQuantity: 400, weightUnit: .grams, isPerishable: false, isOpened: false),
            make("Kidney Beans", .tinsAndCans, quantity: 2, weightQuantity: 400, weightUnit: .grams, isPerishable: false, isOpened: false),
            make("Sweetcorn", .tinsAndCans, quantity: 2, weightQuantity: 325, weightUnit: .grams, isPerishable: false, isOpened: false),
            make("Tuna Chunks", .tinsAndCans, quantity: 2, weightQuantity: 145, weightUnit: .grams, isPerishable: false, isOpened: false),
            make("Coconut Milk", .tinsAndCans, quantity: 2, weightQuantity: 400, weightUnit: .millilitres, isPerishable: false, isOpened: false),
            make("Tinned Peaches", .tinsAndCans, weightQuantity: 400, weightUnit: .grams, isPerishable: false, isOpened: false),
            make("Tomato Soup", .tinsAndCans, quantity: 2, weightQuantity: 400, weightUnit: .grams, isPerishable: false, isOpened: false),
        ]

        // MARK: - Grains & Bakery (8)
        items += [
            make("Spaghetti", .grainsAndBakery, quantity: 2, weightQuantity: 500, weightUnit: .grams, isPerishable: false, isOpened: true),
            make("Penne", .grainsAndBakery, weightQuantity: 500, weightUnit: .grams, isPerishable: false, isOpened: false),
            make("Basmati Rice", .grainsAndBakery, weightQuantity: 1.0, weightUnit: .kilograms, isPerishable: false, isOpened: false),
            make("Couscous", .grainsAndBakery, weightQuantity: 500, weightUnit: .grams, isPerishable: false, isOpened: false),
            make("Noodles", .grainsAndBakery, weightQuantity: 300, weightUnit: .grams, isPerishable: false, isOpened: true),
            make("Bread", .grainsAndBakery, weightQuantity: 800, weightUnit: .grams, isPerishable: true, isOpened: true),
            make("Bagels", .grainsAndBakery, weightQuantity: 5, weightUnit: WeightUnit.none, isPerishable: true, isOpened: true),
            make("Wraps", .grainsAndBakery, weightQuantity: 8, weightUnit: WeightUnit.none, isPerishable: true, isOpened: true),
        ]

        // MARK: - Cooking Ingredients (8)
        items += [
            make("Olive Oil", .cookingIngredients, weightQuantity: 500, weightUnit: .millilitres, isPerishable: false, isOpened: true),
            make("Vegetable Oil", .cookingIngredients, weightQuantity: 1.0, weightUnit: .litres, isPerishable: false, isOpened: false),
            make("Vegetable Stock Cubes", .cookingIngredients, weightQuantity: 12, weightUnit: WeightUnit.none, isPerishable: false, isOpened: false),
            make("Garlic", .cookingIngredients, weightQuantity: 3, weightUnit: WeightUnit.none, isPerishable: true, isOpened: false),
            make("Ginger", .cookingIngredients, weightQuantity: 150, weightUnit: .grams, isPerishable: true, isOpened: false),
            make("Chilli Flakes", .cookingIngredients, weightQuantity: 45, weightUnit: .grams, isPerishable: false, isOpened: true),
            make("Ground Cumin", .cookingIngredients, weightQuantity: 45, weightUnit: .grams, isPerishable: false, isOpened: true),
            make("Salt", .cookingIngredients, weightQuantity: 750, weightUnit: .grams, isPerishable: false, isOpened: true),
        ]

        // MARK: - Snacks & Confectionery (8)
        items += [
            make("Digestive Biscuits", .snacksAndConfectionery, weightQuantity: 300, weightUnit: .grams, isPerishable: false, isOpened: true),
            make("Chocolate Bar", .snacksAndConfectionery, quantity: 3, weightQuantity: 100, weightUnit: .grams, isPerishable: false, isOpened: false),
            make("Crisps Multipack", .snacksAndConfectionery, weightQuantity: 6, weightUnit: WeightUnit.none, isPerishable: false, isOpened: true),
            make("Popcorn", .snacksAndConfectionery, weightQuantity: 90, weightUnit: .grams, isPerishable: false, isOpened: true),
            make("Trail Mix", .snacksAndConfectionery, weightQuantity: 200, weightUnit: .grams, isPerishable: false, isOpened: true),
            make("Jelly Sweets", .snacksAndConfectionery, weightQuantity: 190, weightUnit: .grams, isPerishable: false, isOpened: false),
            make("Cookies", .snacksAndConfectionery, weightQuantity: 200, weightUnit: .grams, isPerishable: false, isOpened: true),
            make("Pretzels", .snacksAndConfectionery, weightQuantity: 175, weightUnit: .grams, isPerishable: false, isOpened: false),
        ]

        // MARK: - Spreads & Condiments (8)
        items += [
            make("Strawberry Jam", .spreadsAndCondiments, weightQuantity: 340, weightUnit: .grams, isPerishable: false, isOpened: true),
            make("Peanut Butter", .spreadsAndCondiments, weightQuantity: 350, weightUnit: .grams, isPerishable: false, isOpened: true),
            make("Tomato Ketchup", .spreadsAndCondiments, weightQuantity: 460, weightUnit: .grams, isPerishable: false, isOpened: true),
            make("Mayonnaise", .spreadsAndCondiments, weightQuantity: 500, weightUnit: .grams, isPerishable: true, isOpened: true),
            make("Soy Sauce", .spreadsAndCondiments, weightQuantity: 150, weightUnit: .millilitres, isPerishable: false, isOpened: true),
            make("Hot Sauce", .spreadsAndCondiments, weightQuantity: 165, weightUnit: .millilitres, isPerishable: false, isOpened: true),
            make("Mustard", .spreadsAndCondiments, weightQuantity: 185, weightUnit: .grams, isPerishable: false, isOpened: true),
            make("BBQ Sauce", .spreadsAndCondiments, weightQuantity: 480, weightUnit: .grams, isPerishable: false, isOpened: false),
        ]

        // MARK: - Beverages (8)
        items += [
            make("Orange Juice", .beverages, weightQuantity: 1.0, weightUnit: .litres, isPerishable: true, isOpened: true),
            make("Apple Juice", .beverages, weightQuantity: 1.0, weightUnit: .litres, isPerishable: true, isOpened: false),
            make("Cola", .beverages, weightQuantity: 2.0, weightUnit: .litres, isPerishable: false, isOpened: false),
            make("Sparkling Water", .beverages, weightQuantity: 6, weightUnit: WeightUnit.none, isPerishable: false, isOpened: false),
            make("Tea Bags", .beverages, weightQuantity: 80, weightUnit: WeightUnit.none, isPerishable: false, isOpened: true),
            make("Ground Coffee", .beverages, weightQuantity: 227, weightUnit: .grams, isPerishable: false, isOpened: true),
            make("Hot Chocolate", .beverages, weightQuantity: 250, weightUnit: .grams, isPerishable: false, isOpened: false),
            make("Oat Drink", .beverages, weightQuantity: 1.0, weightUnit: .litres, isPerishable: true, isOpened: true),
        ]

        // MARK: - Frozen (8)
        items += [
            make("Frozen Peas", .frozen, weightQuantity: 900, weightUnit: .grams, isPerishable: true, isOpened: false),
            make("Frozen Sweetcorn", .frozen, weightQuantity: 900, weightUnit: .grams, isPerishable: true, isOpened: true),
            make("Frozen Mixed Vegetables", .frozen, weightQuantity: 1.0, weightUnit: .kilograms, isPerishable: true, isOpened: false),
            make("Frozen Pizza", .frozen, weightQuantity: 500, weightUnit: .grams, isPerishable: true, isOpened: false),
            make("Fish Fingers", .frozen, weightQuantity: 10, weightUnit: WeightUnit.none, isPerishable: true, isOpened: true),
            make("Frozen Chips", .frozen, weightQuantity: 1.5, weightUnit: .kilograms, isPerishable: true, isOpened: true),
            make("Ice Cream", .frozen, weightQuantity: 900, weightUnit: .millilitres, isPerishable: true, isOpened: true),
            make("Frozen Berries", .frozen, weightQuantity: 500, weightUnit: .grams, isPerishable: true, isOpened: false),
        ]

        // MARK: - Home Baking (8)
        items += [
            make("Plain Flour", .homeBaking, weightQuantity: 1.0, weightUnit: .kilograms, isPerishable: false, isOpened: true),
            make("Self-Raising Flour", .homeBaking, weightQuantity: 1.0, weightUnit: .kilograms, isPerishable: false, isOpened: false),
            make("Caster Sugar", .homeBaking, weightQuantity: 1.0, weightUnit: .kilograms, isPerishable: false, isOpened: true),
            make("Baking Powder", .homeBaking, weightQuantity: 200, weightUnit: .grams, isPerishable: false, isOpened: false),
            make("Chocolate Chips", .homeBaking, weightQuantity: 200, weightUnit: .grams, isPerishable: false, isOpened: true),
            make("Vanilla Extract", .homeBaking, weightQuantity: 38, weightUnit: .millilitres, isPerishable: false, isOpened: true),
            make("Icing Sugar", .homeBaking, weightQuantity: 500, weightUnit: .grams, isPerishable: false, isOpened: false),
            make("Bicarbonate of Soda", .homeBaking, weightQuantity: 200, weightUnit: .grams, isPerishable: false, isOpened: true),
        ]

        // MARK: - Toiletries (8)
        items += [
            make("Shampoo", .toiletries, weightQuantity: 400, weightUnit: .millilitres, isPerishable: false, isOpened: true),
            make("Conditioner", .toiletries, weightQuantity: 400, weightUnit: .millilitres, isPerishable: false, isOpened: true),
            make("Toothpaste", .toiletries, quantity: 2, weightQuantity: 75, weightUnit: .millilitres, isPerishable: false, isOpened: false),
            make("Mouthwash", .toiletries, weightQuantity: 500, weightUnit: .millilitres, isPerishable: false, isOpened: true),
            make("Hand Soap", .toiletries, weightQuantity: 250, weightUnit: .millilitres, isPerishable: false, isOpened: true),
            make("Deodorant", .toiletries, weightQuantity: 150, weightUnit: .millilitres, isPerishable: false, isOpened: false),
            make("Shower Gel", .toiletries, weightQuantity: 500, weightUnit: .millilitres, isPerishable: false, isOpened: true),
            make("Cotton Pads", .toiletries, weightQuantity: 100, weightUnit: WeightUnit.none, isPerishable: false, isOpened: false),
        ]

        // MARK: - Household Essentials (8)
        items += [
            make("Washing Up Liquid", .householdEssentials, weightQuantity: 450, weightUnit: .millilitres, isPerishable: false, isOpened: true),
            make("Laundry Detergent", .householdEssentials, weightQuantity: 1.4, weightUnit: .litres, isPerishable: false, isOpened: true),
            make("Fabric Softener", .householdEssentials, weightQuantity: 1.2, weightUnit: .litres, isPerishable: false, isOpened: true),
            make("Kitchen Roll", .householdEssentials, weightQuantity: 2, weightUnit: WeightUnit.none, isPerishable: false, isOpened: false),
            make("Toilet Roll", .householdEssentials, weightQuantity: 9, weightUnit: WeightUnit.none, isPerishable: false, isOpened: false),
            make("Bin Bags", .householdEssentials, weightQuantity: 30, weightUnit: WeightUnit.none, isPerishable: false, isOpened: true),
            make("Surface Cleaner", .householdEssentials, weightQuantity: 750, weightUnit: .millilitres, isPerishable: false, isOpened: true),
            make("Disinfectant Wipes", .householdEssentials, weightQuantity: 80, weightUnit: WeightUnit.none, isPerishable: false, isOpened: true),
        ]

        // MARK: - Baby Supplies (8)
        items += [
            make("Nappies", .babySupplies, weightQuantity: 44, weightUnit: WeightUnit.none, isPerishable: false, isOpened: true),
            make("Baby Wipes", .babySupplies, weightQuantity: 80, weightUnit: WeightUnit.none, isPerishable: false, isOpened: true),
            make("Baby Shampoo", .babySupplies, weightQuantity: 250, weightUnit: .millilitres, isPerishable: false, isOpened: false),
            make("Nappy Cream", .babySupplies, weightQuantity: 100, weightUnit: .grams, isPerishable: false, isOpened: true),
            make("Baby Lotion", .babySupplies, weightQuantity: 200, weightUnit: .millilitres, isPerishable: false, isOpened: true),
            make("Formula Powder", .babySupplies, weightQuantity: 800, weightUnit: .grams, isPerishable: false, isOpened: false),
            make("Baby Food Pouches", .babySupplies, quantity: 6, weightQuantity: 90, weightUnit: .grams, isPerishable: true, isOpened: false),
            make("Teething Biscuits", .babySupplies, weightQuantity: 100, weightUnit: .grams, isPerishable: false, isOpened: true),
        ]

        // MARK: - Pet Supplies (8)
        items += [
            make("Dog Dry Food", .petSupplies, weightQuantity: 2.0, weightUnit: .kilograms, isPerishable: false, isOpened: true),
            make("Cat Dry Food", .petSupplies, weightQuantity: 1.5, weightUnit: .kilograms, isPerishable: false, isOpened: true),
            make("Cat Food Pouches", .petSupplies, weightQuantity: 12, weightUnit: WeightUnit.none, isPerishable: false, isOpened: false),
            make("Dog Treats", .petSupplies, weightQuantity: 180, weightUnit: .grams, isPerishable: false, isOpened: true),
            make("Cat Litter", .petSupplies, weightQuantity: 10, weightUnit: .kilograms, isPerishable: false, isOpened: true),
            make("Pet Shampoo", .petSupplies, weightQuantity: 250, weightUnit: .millilitres, isPerishable: false, isOpened: false),
            make("Bird Seed", .petSupplies, weightQuantity: 1.0, weightUnit: .kilograms, isPerishable: false, isOpened: false),
            make("Fish Food Flakes", .petSupplies, weightQuantity: 100, weightUnit: .grams, isPerishable: false, isOpened: true),
        ]

        return items
    }
    
    static func generateSampleLabels() -> [ItemLabel] {
        let names = [
            "Stale",
            "Going Off",
            "Vegan",
            "Gluten Free",
            "Birthday",
            "Use Soon"
        ]
        
        let availableColors = AppStyle.labelColors
        
        return names.enumerated().map { index, name in
            let color = availableColors[index % availableColors.count]
            return ItemLabel(name: name, color: color)
        }
    }
    
    @MainActor
    static func assignRandomAddedDates(to pantry: PantryViewModel) {
        
        struct SeededRNG: RandomNumberGenerator {
            private var state: UInt64
            init(seed: UInt64) { self.state = seed }
            mutating func next() -> UInt64 {
                state &+= 0x9E3779B97F4A7C15
                var z = state
                z = (z ^ (z >> 30)) &* 0xBF58476D1CE4E5B9
                z = (z ^ (z >> 27)) &* 0x94D049BB133111EB
                return z ^ (z >> 31)
            }
        }

        var rng = SeededRNG(seed: 0xEAD2026)

        let now = Date()
        let sixMonths: TimeInterval = 60 * 60 * 24 * 30 * 6
        
        for items in pantry.itemsByCategory.values {
            for item in items {
                
                // Bias toward recent dates using exponential distribution
                let uniform = Double.random(in: 0...1, using: &rng)
                
                // Skew so more items are recent
                let biased = pow(uniform, 2.2)
                
                let randomInterval = biased * sixMonths
                let randomDate = now.addingTimeInterval(-randomInterval)
                
                var updatedItem = item
                updatedItem.dateAdded = randomDate
                
                pantry.updateItem(updatedItem: updatedItem)
            }
        }
    }
}
