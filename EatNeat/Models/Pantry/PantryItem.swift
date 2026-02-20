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
    
    var imageURL: URL? // a pointer on OpenFoodFacts to an image of the product, if it doesnt exist, a fallback is rendered
    var imageSearchState: ImageSearchState = .notAttempted // has our model tried to find a URL -> prevents duplicated attempts to call the API
    
    var labels: Set<ItemLabel>
    
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
        dateAdded: Date = Date(),
        labels: Set<ItemLabel> = [],
        imageURL: URL? = nil
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
        self.labels = labels
        self.imageURL = imageURL
        
        if self.imageURL != nil {
            self.imageSearchState = .done // we've got the image URL now so don't bother looking again
        }
    }
    
    mutating func clearLabels() {
        labels.removeAll()
    }
    
    /// Given a label, either deselects or selects it based on whether the item had it.
    mutating func toggleLabel(_ label: ItemLabel) {
        if labels.contains(label) {
            labels.remove(_: label)
        } else {
            labels.insert(_: label)
        }
    }
    
    /// Mark an image on an item as the required state to prevent race conditions & duplicate API calls to OFF.
    mutating func reportImageSearchState(state: ImageSearchState) {
        self.imageSearchState = state
    }
}
