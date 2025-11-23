//
//  PantryViewModel.swift
//  EatNeat
//
//  Created by Oscar Horner on 17/10/2025.
//

import Foundation

class PantryViewModel: ObservableObject {
    @Published private(set) var itemsByCategory: [Category: [PantryItem]] = [:] // dictionary mapping categories to the item list that belongs to them
    
    private var saveURL: URL {
        let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        return url.appendingPathComponent("Pantry.json")
    } // final path for JSON data when application is inactive
    
    
    init() {
        // Initialise all categories with empty arrays so every category key exists
        for category in Category.allCases {
            itemsByCategory[category] = []
        }
        
        load()
    }
    
    /// Adds a PantryItem instance according to primitive required data
    func addItem(name: String, category: Category, quantity: Int = 1, weight: Double? = nil) {
        let newItem = PantryItem(quantity: quantity, weight: weight, name: name, category: category)
        itemsByCategory[category, default: []].append(newItem)
        save()
    }
    
    /// Adds a concrete PantryItem instance
    func addItem(item: PantryItem) {
        itemsByCategory[item.category, default: []].append(item)
        save()
    }
    
    /// Clears pantry
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
    
    // MARK: Persistence: ensure that model persists between restarts and can be synced with iCloud
    
    func save() {
        do {
            let data = try JSONEncoder().encode(itemsByCategory)
            try FileManager.default.createDirectory(
                at: saveURL.deletingLastPathComponent(),
                withIntermediateDirectories: true
            )
            try data.write(to: saveURL)
        } catch {
            print("Failed to save pantry: ", error)
        }
    }
    
    func load() {
        do {
            let data = try Data(contentsOf: saveURL)
            let decoded = try JSONDecoder().decode([Category: [PantryItem]].self, from: data)
            itemsByCategory = decoded
        } catch {
            print("No existing pantry or failed to load: ", error)
        }
    }
}
