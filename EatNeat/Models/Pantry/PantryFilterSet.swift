//
//  PantryFilterSet.swift
//  EatNeat
//
//  Created by Oscar Horner on 17/02/2026.
//
// Represents a full configuration of filters that a user can apply to a set of PantryItems, including custom attribute filters (PantryFilter), category and label criteria.

struct PantryFilterSet {
    var attributeFilters: [PantryFilter] = []
    
    var categoryFilters: [Category] = []
    var includeCategories: Bool = true // do we want items to be in this category (true) or not
    
    var labelFilters: Set<ItemLabel> = []
    var includeLabels: Bool = true // do we want items to have these labels (true) or not
    
    var searchTerm: String = "" // if we're using a searchbar then the search term to match items by
    
    func count() -> Int {
        var count = 0
        
        count += attributeFilters.count
        
        count += (categoryFilters.isEmpty) ? 0 : 1
        count += (labelFilters.isEmpty) ? 0 : 1
        
        return count
    }
}

extension PantryFilterSet {

    func matches(_ item: PantryItem) -> Bool {
        
        // Searching - does the item match our active search constraint?
        if !searchTerm.isEmpty {
            if !item.name.localizedCaseInsensitiveContains(searchTerm) {
                return false
            }
        }

        // Attribute filters - does the item satisfy every active attribute filter (e.g. "is" "perishable" or "expires" ">" "7 days"
        let attributesMatch = attributeFilters.allSatisfy {
            $0.matches(item)
        }

        guard attributesMatch else { return false }

        // Category filter
        if !categoryFilters.isEmpty {
            let contains = categoryFilters.contains(item.category)

            if includeCategories && !contains { return false }
            if !includeCategories && contains { return false }
        }

        // Label filter
        if !labelFilters.isEmpty {

            let contains = labelFilters.contains { filterLabel in
                item.labels.contains(filterLabel)
            }

            if includeLabels && !contains { return false }
            if !includeLabels && contains { return false }
        }

        return true
    }
}

