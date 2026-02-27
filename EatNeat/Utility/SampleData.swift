// Code (including product data) entirely synthesised by Generative AI.

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

        // MARK: - Fruit & Vegetables
        items += [
            make("Tesco Bananas 6 Pack", .fruitAndVegetables, weightQuantity: 6, weightUnit: WeightUnit.none, isPerishable: true, isOpened: false),
            make("Tesco British Gala Apples", .fruitAndVegetables, weightQuantity: 6, weightUnit: WeightUnit.none, isPerishable: true, isOpened: false),
            make("Tesco Carrots 1kg", .fruitAndVegetables, weightQuantity: 1.0, weightUnit: .kilograms, isPerishable: true, isOpened: false),
            make("Tesco Cherry Tomatoes", .fruitAndVegetables, weightQuantity: 250, weightUnit: .grams, isPerishable: true, isOpened: true),
            make("Tesco White Potatoes 2.5kg", .fruitAndVegetables, weightQuantity: 2.5, weightUnit: .kilograms, isPerishable: false, isOpened: false),
            make("Tesco Broccoli", .fruitAndVegetables, weightQuantity: 335, weightUnit: .grams, isPerishable: true, isOpened: false),
        ]

        // MARK: - Dairy
        items += [
            make("Tesco British Semi Skimmed Milk", .dairy, weightQuantity: 2.272, weightUnit: .litres, isPerishable: true, isOpened: true),
            make("Tesco Salted Butter 250g", .dairy, weightQuantity: 250, weightUnit: .grams, isPerishable: true, isOpened: true),
            make("Cathedral City Mature Cheddar", .dairy, weightQuantity: 350, weightUnit: .grams, isPerishable: true, isOpened: true),
            make("Tesco Greek Style Yogurt 500g", .dairy, weightQuantity: 500, weightUnit: .grams, isPerishable: true, isOpened: false),
            make("Tesco British Free Range Eggs 12 Pack", .dairy, weightQuantity: 12, weightUnit: WeightUnit.none, isPerishable: true, isOpened: false),
            make("Galbani Mozzarella", .dairy, weightQuantity: 125, weightUnit: .grams, isPerishable: true, isOpened: false),
        ]

        // MARK: - Meat
        items += [
            make("Tesco British Chicken Breast Fillets", .meat, weightQuantity: 600, weightUnit: .grams, isPerishable: true, isOpened: false),
            make("Tesco Lean Beef Steak Mince 500g", .meat, weightQuantity: 500, weightUnit: .grams, isPerishable: true, isOpened: false),
            make("Tesco Smoked Back Bacon", .meat, weightQuantity: 300, weightUnit: .grams, isPerishable: true, isOpened: true),
            make("Richmond Pork Sausages 8 Pack", .meat, weightQuantity: 8, weightUnit: WeightUnit.none, isPerishable: true, isOpened: false),
            make("Tesco British Rump Steak", .meat, weightQuantity: 2, weightUnit: WeightUnit.none, isPerishable: true, isOpened: false),
        ]

        // MARK: - Tins & Cans
        items += [
            make("Heinz Baked Beans", .tinsAndCans, quantity: 3, weightQuantity: 415, weightUnit: .grams, isPerishable: false, isOpened: false),
            make("Tesco Chopped Tomatoes 400g", .tinsAndCans, quantity: 4, weightQuantity: 400, weightUnit: .grams, isPerishable: false, isOpened: false),
            make("Tesco Red Kidney Beans", .tinsAndCans, quantity: 2, weightQuantity: 400, weightUnit: .grams, isPerishable: false, isOpened: false),
            make("Princes Tuna Chunks", .tinsAndCans, quantity: 2, weightQuantity: 145, weightUnit: .grams, isPerishable: false, isOpened: false),
            make("Tesco Coconut Milk 400ml", .tinsAndCans, quantity: 2, weightQuantity: 400, weightUnit: .millilitres, isPerishable: false, isOpened: false),
            make("Heinz Cream of Tomato Soup", .tinsAndCans, quantity: 2, weightQuantity: 400, weightUnit: .grams, isPerishable: false, isOpened: false),
        ]

        // MARK: - Grains & Bakery
        items += [
            make("Warburtons Toastie Bread", .grainsAndBakery, weightQuantity: 800, weightUnit: .grams, isPerishable: true, isOpened: true),
            make("Tesco Plain Tortilla Wraps", .grainsAndBakery, weightQuantity: 8, weightUnit: WeightUnit.none, isPerishable: true, isOpened: true),
            make("Tesco Spaghetti 500g", .grainsAndBakery, quantity: 2, weightQuantity: 500, weightUnit: .grams, isPerishable: false, isOpened: true),
            make("Tilda Basmati Rice", .grainsAndBakery, weightQuantity: 1.0, weightUnit: .kilograms, isPerishable: false, isOpened: false),
            make("Tesco Couscous", .grainsAndBakery, weightQuantity: 500, weightUnit: .grams, isPerishable: false, isOpened: false),
            make("New York Bakery Bagels 5 Pack", .grainsAndBakery, weightQuantity: 5, weightUnit: WeightUnit.none, isPerishable: true, isOpened: true),
        ]

        // MARK: - Snacks & Confectionery
        items += [
            make("Cadbury Dairy Milk Chocolate Bar", .snacksAndConfectionery, quantity: 3, weightQuantity: 100, weightUnit: .grams, isPerishable: false, isOpened: false),
            make("McVitie's Digestive Biscuits", .snacksAndConfectionery, weightQuantity: 400, weightUnit: .grams, isPerishable: false, isOpened: true),
            make("Tesco Ready Salted Crisps 6 Pack", .snacksAndConfectionery, weightQuantity: 6, weightUnit: WeightUnit.none, isPerishable: false, isOpened: true),
            make("Butterkist Salted Popcorn", .snacksAndConfectionery, weightQuantity: 100, weightUnit: .grams, isPerishable: false, isOpened: true),
            make("Tesco Chocolate Chip Cookies", .snacksAndConfectionery, weightQuantity: 200, weightUnit: .grams, isPerishable: false, isOpened: true),
            make("Haribo Starmix", .snacksAndConfectionery, weightQuantity: 190, weightUnit: .grams, isPerishable: false, isOpened: false),
        ]

        // MARK: - Beverages
        items += [
            make("Tesco Pure Orange Juice 1L", .beverages, weightQuantity: 1.0, weightUnit: .litres, isPerishable: true, isOpened: true),
            make("Innocent Apple Juice", .beverages, weightQuantity: 1.0, weightUnit: .litres, isPerishable: true, isOpened: false),
            make("Coca-Cola Original Taste 2L", .beverages, weightQuantity: 2.0, weightUnit: .litres, isPerishable: false, isOpened: false),
            make("Tesco Sparkling Water 6 Pack", .beverages, weightQuantity: 6, weightUnit: WeightUnit.none, isPerishable: false, isOpened: false),
            make("Tetley Tea Bags 80 Pack", .beverages, weightQuantity: 80, weightUnit: WeightUnit.none, isPerishable: false, isOpened: true),
            make("Nescafé Gold Blend", .beverages, weightQuantity: 200, weightUnit: .grams, isPerishable: false, isOpened: true),
        ]

        // MARK: - Frozen
        items += [
            make("Tesco Garden Peas 900g", .frozen, weightQuantity: 900, weightUnit: .grams, isPerishable: true, isOpened: false),
            make("Tesco Homestyle Oven Chips 1.5kg", .frozen, weightQuantity: 1.5, weightUnit: .kilograms, isPerishable: true, isOpened: true),
            make("Chicago Town Deep Dish Pepperoni Pizza", .frozen, weightQuantity: 435, weightUnit: .grams, isPerishable: true, isOpened: false),
            make("Birds Eye 10 Fish Fingers", .frozen, weightQuantity: 10, weightUnit: WeightUnit.none, isPerishable: true, isOpened: true),
            make("Tesco Frozen Summer Fruits", .frozen, weightQuantity: 500, weightUnit: .grams, isPerishable: true, isOpened: false),
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
    
    /// Return sample data for the Donation viewer with dummy item rankings
    static func sampleFoodbankDonationData() -> [FoodbankCard] {

        func relativeText(_ date: Date) -> String {
            let formatter = RelativeDateTimeFormatter()
            formatter.unitsStyle = .short
            return formatter.localizedString(for: date, relativeTo: .now)
        }

        func makePrompts(
            foodbankID: String,
            pairs: [(item: String, need: String)]
        ) -> [DonationPromptDisplay] {

            pairs.enumerated().map { index, pair in
                DonationPromptDisplay(
                    id: "\(foodbankID)-\(index)",
                    needID: UUID(),
                    needName: pair.need,
                    itemID: UUID(),
                    itemName: pair.item,
                    behaviouralScore: Double.random(in: 0.6...0.95),
                    semanticScore: Double.random(in: 0.65...0.98),
                    finalScore: Double.random(in: 0.7...0.99)
                )
            }
        }

        let now = Date()

        return [

            // MARK: Coventry
            FoodbankCard(
                id: "coventry",
                name: "Coventry Foodbank",
                distanceMeters: 1800,
                distanceText: "1.8 km away",
                needsLastUpdated: now.addingTimeInterval(-3600 * 6),
                needsLastUpdatedText: relativeText(now.addingTimeInterval(-3600 * 6)),
                isFavourite: true,
                needs: [
                    Need(id: UUID(), name: "Toothpaste"),
                    Need(id: UUID(), name: "Tinned Vegetables"),
                    Need(id: UUID(), name: "Pasta"),
                    Need(id: UUID(), name: "Rice"),
                    Need(id: UUID(), name: "Cereal")
                ],
                surpluses: [
                    "Baked Beans",
                    "Instant Noodles"
                ],
                donationPrompts: makePrompts(
                    foodbankID: "coventry",
                    pairs: [
                        ("Colgate Toothpaste", "Toothpaste"),
                        ("Tesco Wholemeal Pasta", "Pasta"),
                        ("Heinz Baked Beans", "Tinned Vegetables"),
                        ("Long Grain Rice", "Rice"),
                        ("Corn Flakes", "Cereal")
                    ]
                )
            ),

            // MARK: Warwick
            FoodbankCard(
                id: "warwick",
                name: "Warwick District Foodbank",
                distanceMeters: 4200,
                distanceText: "4.2 km away",
                needsLastUpdated: now.addingTimeInterval(-3600 * 24),
                needsLastUpdatedText: relativeText(now.addingTimeInterval(-3600 * 24)),
                isFavourite: false,
                needs: [
                    Need(id: UUID(), name: "Baby Food"),
                    Need(id: UUID(), name: "Nappies"),
                    Need(id: UUID(), name: "Tinned Fruit"),
                    Need(id: UUID(), name: "Jam")
                ],
                surpluses: [
                    "Pasta",
                    "Rice"
                ],
                donationPrompts: makePrompts(
                    foodbankID: "warwick",
                    pairs: [
                        ("Ella's Kitchen Pouches", "Baby Food"),
                        ("Pampers Size 4", "Nappies"),
                        ("Tinned Peaches", "Tinned Fruit"),
                        ("Strawberry Jam", "Jam")
                    ]
                )
            ),

            // MARK: Leamington
            FoodbankCard(
                id: "leamington",
                name: "Leamington Spa Foodbank",
                distanceMeters: 950,
                distanceText: "950 m away",
                needsLastUpdated: now.addingTimeInterval(-3600 * 3),
                needsLastUpdatedText: relativeText(now.addingTimeInterval(-3600 * 3)),
                isFavourite: false,
                needs: [
                    Need(id: UUID(), name: "UHT Milk"),
                    Need(id: UUID(), name: "Tea Bags"),
                    Need(id: UUID(), name: "Sugar"),
                    Need(id: UUID(), name: "Cooking Oil")
                ],
                surpluses: [
                    "Breakfast Cereal",
                    "Tinned Sweetcorn"
                ],
                donationPrompts: makePrompts(
                    foodbankID: "leamington",
                    pairs: [
                        ("UHT Semi-Skimmed Milk", "UHT Milk"),
                        ("PG Tips Tea Bags", "Tea Bags"),
                        ("Granulated Sugar 1kg", "Sugar"),
                        ("Sunflower Oil 1L", "Cooking Oil")
                    ]
                )
            ),

            // MARK: Kenilworth
            FoodbankCard(
                id: "kenilworth",
                name: "Kenilworth Community Foodbank",
                distanceMeters: 6100,
                distanceText: "6.1 km away",
                needsLastUpdated: now.addingTimeInterval(-3600 * 48),
                needsLastUpdatedText: relativeText(now.addingTimeInterval(-3600 * 48)),
                isFavourite: false,
                needs: [
                    Need(id: UUID(), name: "Soap"),
                    Need(id: UUID(), name: "Shampoo"),
                    Need(id: UUID(), name: "Tinned Soup")
                ],
                surpluses: [
                    "Baked Beans",
                    "Spaghetti Hoops"
                ],
                donationPrompts: makePrompts(
                    foodbankID: "kenilworth",
                    pairs: [
                        ("Dove Soap Bars", "Soap"),
                        ("Head & Shoulders Shampoo", "Shampoo"),
                        ("Tomato Soup", "Tinned Soup")
                    ]
                )
            )
        ]
    }
}
