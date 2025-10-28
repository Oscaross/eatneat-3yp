//
//  PantryView.swift
//  EatNeat
//
//  Created by Oscar Horner on 17/10/2025.
//

import Foundation

class PantryViewModel: ObservableObject {
    @Published private(set) var itemsByCategory: [Category: [PantryItem]] = [:]
    
    init() {
        // Initialise all categories with empty arrays so every category key exists
        for category in Category.allCases {
            itemsByCategory[category] = []
        }
    }
    
    func addItem(name: String, category: Category, quantity: Int = 1, weight: Double? = nil) {
        let newItem = PantryItem(quantity: quantity, weight: weight, name: name, category: category)
        itemsByCategory[category, default: []].append(newItem)
    }
    
    func addItem(item: PantryItem) {
        itemsByCategory[item.category, default: []].append(item)
    }
    
    func clearPantry() {
        for category in Category.allCases {
            itemsByCategory[category] = []
        }
    }
}
