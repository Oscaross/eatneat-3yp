//
//  Category.swift
//  EatNeat
//
//  Created by Oscar Horner on 23/09/2025.
//

enum Category: String, CaseIterable, Identifiable, Codable {
    var id: String { rawValue } // list-iterable
    case grainsAndPasta = "Grains & Pasta"
    case cannedAndJarred = "Canned & Jarred Goods"
    case bakingIngredients = "Baking Ingredients"
    case oilsVinegarsAndCondiments = "Oils, Vinegars & Condiments"
    case spicesAndSeasonings = "Spices & Seasonings"
    case snacksAndConfectionery = "Snacks & Confectionery"
    case cerealsAndBreakfast = "Cereals & Breakfast Foods"
    case beverages = "Beverages (Non-Alcoholic)"
    case dairyAndAlternatives = "Dairy & Alternatives"
    case eggs = "Eggs"
    case freshProduce = "Fresh Produce"
    case frozenFoods = "Frozen Foods"
    case meatAndPoultry = "Meat & Poultry"
    case seafood = "Seafood"
    case breadAndBakery = "Bread & Bakery"
    case soupsAndReadyMeals = "Soups & Ready Meals"
    case nutsSeedsAndDriedFruit = "Nuts, Seeds & Dried Fruit"
    case saucesAndSpreads = "Sauces & Spreads"
    case plantBasedAndVegetarian = "Plant-Based & Vegetarian Products"
    case specialtyAndInternational = "Specialty & International Foods"
    case none = "None"
}
