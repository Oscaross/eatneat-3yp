//
//  PantryItem.swift
//  EatNeat
//
//  Created by Oscar Horner on 23/09/2025.
//

import Foundation

struct PantryItem: Identifiable, Hashable {
    let id: UUID = UUID()
    var quantity: Int
    var weight: Double?
    var name: String
    var category: Category
    var dateAdded: Date
    
    init(quantity: Int, weight: Double? = nil, name: String, category: Category) {
        self.quantity = quantity
        self.weight = weight
        self.name = name
        self.category = category
        self.dateAdded = Date()
    }
    
}
