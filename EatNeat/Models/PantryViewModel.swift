//
//  PantryViewModel.swift
//  EatNeat
//
//  Created by Oscar Horner on 17/10/2025.
//

import Foundation

class PantryViewModel: ObservableObject {
    @Published private(set) var itemsByCategory: [Category: [PantryItem]] = [:] // dictionary mapping categories to the item list that belongs to them
    @Published var donationCount: Int = 0 // number of items donated by the user
    @Published var userLabels: [ItemLabel] = [] // custom labels created by the user
    
    private var saveURL: URL {
        let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        return url.appendingPathComponent("Pantry.json")
    } // final path for JSON data when application is inactive
    
    
    init() {
        // Create empty categories on first launch
        for category in Category.allCases {
            itemsByCategory[category] = []
        }
        
        load()
        
        userLabels = SampleData.generateSampleLabels() // TODO: Make labels non-sample and configured by user
    }

    
    /// Adds a PantryItem instance according to primitive required data
    func addItem(
        name: String,
        category: Category,
        quantity: Int = 1,
        weightQuantity: Double? = nil,
        weightUnit: WeightUnit? = nil,
        isPerishable: Bool = false,
        isOpened: Bool = false,
        expiry: Date? = nil,
        cost: Double? = nil
    ) {
        let newItem = PantryItem(
            name: name,
            category: category,
            quantity: quantity,
            weightQuantity: weightQuantity,
            weightUnit: weightUnit,
            isOpened: isOpened,
            isPerishable: isPerishable,
            expiry: expiry,
            cost: cost
        )

        itemsByCategory[category, default: []].append(newItem)
        save()
    }

    
    /// Adds a concrete PantryItem instance
    func addItem(item: PantryItem) {
        itemsByCategory[item.category, default: []].append(item)
        save()
    }
    
    /// Removes  a concrete PantryItem instance
    func removeItem(item: PantryItem) {
        for category in Category.allCases {
            if let index = itemsByCategory[category]?.firstIndex(of: item) {
                itemsByCategory[category]?.remove(at: index)
                save()
                return
            }
        }
    }
    
    func updateItem(itemID: UUID, updatedItem: PantryItem) {
        for (category, items) in itemsByCategory {
            if let index = items.firstIndex(where: { $0.id == itemID }) {
                itemsByCategory[category]?[index] = updatedItem
                return
            }
        }
    }
    
    func clearPantry() {
        for category in Category.allCases {
            itemsByCategory[category] = []
        }
        save()
    }

    /// Returns the PantryItem with the given UUID, or nil if not found.
    func getItemByID(itemID: UUID) -> PantryItem? {
        for category in Category.allCases {
            if let item = itemsByCategory[category]?.first(where: { $0.id == itemID }) {
                return item
            }
        }
        return nil
    }
    
    /// Returns all items, regardless of category.
    func getAllItems() -> [PantryItem] {
        var allItems: [PantryItem] = []
        
        for category in Category.allCases {
            if let items = itemsByCategory[category] {
                allItems.append(contentsOf: items)
            }
        }
            
        return allItems
    }
    
    
    /// Prints all entries to the pantry as a comma-separated string including their UUIDs.
    func printAllPantryEntries() -> String {
        var result = ""
        
        for category in Category.allCases {
            for item in itemsByCategory[category] ?? [] {
                result += "\(item.name) (ID: \(item.id)), "
            }
        }
        
        return result
    }
    
    /// Registers in the pantry that a user has donated an item.
    func markItemDonated(item: PantryItem) {
        // TODO: Implement proper donation tracking
        donationCount += 1
        print("Item donated : \(item.name). Donation count is now \(donationCount)")
        removeItem(item: item)
    }
    
    /// Saves pantry data for object persistence when the app restarts.
    private func save() {
        try? SaveManager.shared.save(itemsByCategory, forKey: "Pantry")
        try? SaveManager.shared.save(donationCount, forKey: "DonationCount")
        try? SaveManager.shared.save(userLabels, forKey: "UserLabels")
    }
    
    /// Load saved data for object persistence.
    private func load() {
        // If saved itemsByCategory is already present, then use this instead
        if let saved = try? SaveManager.shared.load([Category: [PantryItem]].self,
            forKey: "Pantry") {
                itemsByCategory = saved
            }
        // If saved donation count is already present, then use this instead
        if let donationCount = try? SaveManager.shared.load(Int.self,
            forKey: "DonationCount") {
                self.donationCount = donationCount
            }
        
        if let savedLabels = try? SaveManager.shared.load([ItemLabel].self,
                                                          forKey: "UserLabels") {
            self.userLabels = savedLabels
        }
    }
}
