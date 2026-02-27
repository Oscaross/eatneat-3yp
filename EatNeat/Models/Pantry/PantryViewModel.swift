//
//  PantryViewModel.swift
//  EatNeat
//
//  Created by Oscar Horner on 17/10/2025.
//
// Model that maintains, saves, loads and organises members of the users' pantry. 

import Foundation
import SwiftUI

@MainActor
class PantryViewModel: ObservableObject {
    @Published private(set) var itemsByCategory: [Category: [PantryItem]] = [:] // dictionary mapping categories to the item list that belongs to them
    @Published var donationCount: Int = 0 // number of items donated by the user
    @Published private var userLabels: [ItemLabel] = [] // custom labels created by the user
    @Published var filter: PantryFilterSet // the current filter that the user has active
    @Published var searchTerm: String = "" // if the user is currently searching for an item the term that they are searching for
    
    /// Storage object that stores information
    var userItemHabits: [String : PantryItemHabits]
    
    private var lastRemovedItem: PantryItem? // store the last deleted item for undo functionality
    
    private var saveURL: URL {
        let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        return url.appendingPathComponent("Pantry.json")
    } // final path for JSON data when application is inactive
    
    
    init() {
        filter = PantryFilterSet()
        
        // Create empty categories on first launch
        for category in Category.allCases {
            itemsByCategory[category] = []
        }
        
        load()
        
        userLabels = SampleData.generateSampleLabels() // TODO: Make labels non-sample and configured by user
    }
    
    var filteredItems: [PantryItem] {
        itemsByCategory.values
            .flatMap { $0 }
            .filter { item in
                let matchesSearch =
                    searchTerm.isEmpty ||
                    item.name.localizedCaseInsensitiveContains(searchTerm)

                return matchesSearch && filter.matches(item)
            }
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

        addItem(item: newItem)
    }
    
    /// Adds a concrete PantryItem instance
    func addItem(item: PantryItem) {
        itemsByCategory[item.category, default: []].append(item)
        save()
        
        let id = item.id
        Task { [weak self] in
            await self?.addImageForItem(for: id)
        }
    }
    
    /// Adds a ItemLabel instance according to primitive required data.
    func addLabel(name: String, color: Color) {
        userLabels.append(_: ItemLabel(name: name, color: color))
        save()
    }
    
    /// Removes an ItemLabel instance
    func removeLabel(label: ItemLabel) {
        userLabels.removeAll { $0.id == label.id }
    }
    
    
    /// Removes  a concrete PantryItem instance
    func removeItem(item: PantryItem) {
        for category in Category.allCases {
            if let idx = itemsByCategory[category]?.firstIndex(of: item) {
                lastRemovedItem = itemsByCategory[category]?[idx]
                itemsByCategory[category]?.remove(at: idx)
                save()
                return
            }
        }
    }
    
    /// Removes a PantryItem instance by its unique ID
    func removeItem(itemID: UUID) {
        for category in Category.allCases {
            if let idx = itemsByCategory[category]?.firstIndex(where: { $0.id == itemID }) {
                lastRemovedItem = itemsByCategory[category]?[idx]
                itemsByCategory[category]?.remove(at: idx)
                save()
            }
        }
    }
    
    /// If possible, undoes the last removal that occured.
    func undoLastRemoval() {
        if let item = lastRemovedItem {
            addItem(item: item)
            lastRemovedItem = nil
            save()
        }
    }
    
    /// Updates a PantryItem to the new draft
    func updateItem(updatedItem: PantryItem) {
        upsert(updatedItem)
        save()
    }
    
    /// Remove all items in the pantry
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
    
    /// Returns an ordered collection of the users' labels
    func getUserLabels() -> [ItemLabel] {
        return userLabels.sorted(by: { $0.name < $1.name })
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
    
    private func upsert(_ updated: PantryItem) {
        // Replace if found anywhere (even if category changed)
        for category in Category.allCases {
            if let idx = itemsByCategory[category]?.firstIndex(where: { $0.id == updated.id }) {
                itemsByCategory[category]?.remove(at: idx)
                break
            }
        }
        // Insert into its (possibly new) category
        itemsByCategory[updated.category, default: []].append(updated)
    }
    
    @MainActor
    private func addImageForItem(for id: UUID) async {
        guard var item = getItemByID(itemID: id)else { return }

        // Only attempt when needed
        guard item.imageURL == nil else { return }
        guard item.imageSearchState == .notAttempted else { return }

        // Mark in-progress
        item.imageSearchState = .inProgress
        upsert(item)
        save()

        do {
            // This should ideally return URL? (nil if no confident match)
            let url = try await ItemImageAPI.getProductImageURL(productName: item.name)

            guard var latest = getItemByID(itemID: id) else { return }
            latest.imageURL = url
            latest.imageSearchState = .done
            upsert(latest)
            save()
        } catch {
            guard var latest = getItemByID(itemID: id) else { return }
            latest.imageSearchState = .failed
            upsert(latest)
            save()
        }
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
