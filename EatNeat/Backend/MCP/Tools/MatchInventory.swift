//
//  MatchInventory.swift
//  EatNeat
//
//  Created by Oscar Horner on 26/10/2025.
//

struct MatchInventoryTool {
    /// MCP tool. Given a set of item names in a pantry and a set of item names that nearby foodbanks require, as well as the foodbank names:
    /// 1. Finds the relevant reference to the item in the pantry and details of the foodbank.
    /// 2. Adds to a list of candidates
    /// 3. Prepares the list to notify the user and inform them of where the item is required.
    ///
    /// Fails if no (exact) match to the string in the user's pantry could be located.
    public static func matchInventory(itemOwned : String, foodbankMatch : String, foodbankName : String) {
        print("I am trying to match " + itemOwned + " with food bank " + foodbankName)
    }
}
