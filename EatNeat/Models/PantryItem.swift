//
//  PantryItem.swift
//  EatNeat
//
//  Created by Oscar Horner on 23/09/2025.
//

import Foundation

struct PantryItem: Identifiable, Hashable, Codable {
    let id: UUID
    
    var name: String
    var category: Category
    var quantity: Int

    
    var weightUnit: WeightUnit? // the unit of the quantity (ie. ml, g, kg ...)
    var weightQuantity: Double? // the absolute value of whatever quantity was given (ie. 500 for 500ml of soap)

    var isOpened: Bool
    var isPerishable : Bool // perishable goods go off typically in less than 2 weeks
    var expiry: Date?
    var cost: Double?
    
    var dateAdded: Date
    
    var label: ItemLabel?
    
    init(
        id: UUID = UUID(),
        name: String,
        category: Category,
        quantity: Int,
        weightQuantity: Double? = nil,
        weightUnit: WeightUnit? = nil,
        isOpened: Bool = false,
        isPerishable: Bool,
        expiry: Date? = nil,
        cost: Double? = nil,
        dateAdded: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.quantity = quantity
        
        self.weightQuantity = weightQuantity
        self.weightUnit = weightUnit
        
        self.isOpened = isOpened
        self.isPerishable = isPerishable
        self.expiry = expiry
        self.cost = cost
        
        self.dateAdded = dateAdded
    }
}
