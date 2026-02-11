//
//  Instructions.swift
//  EatNeat
//
//  Created by Oscar Horner on 04/12/2025.
//
// This class handles the building of detailed instructions objects for agents to use as MCP requests. For each MCP tooling, there is a corresponding request function.

// TODO: Optimise in the future to minimise token cost.

import Foundation

class MCPInstructions {
    /// Given some foodbank needs and a list of items which the matching should be done against, return a detailed instruction set for an MCP agent to follow to match items to needs.
    public static func matchItemToNeedsInstructions(needs: FoodbankNeeds, items: [PantryItem]) -> String {
        let preamble = "You are an agent tasked with matching foodbank needs to available pantry items. Use the MCP tool provided to register a match between an item and a need. Only match an item to one need. The foodbank ID is \(needs.id)."
        
        var needsInstructions = "\n The needs: "
        
        for need in needs.needsList {
            needsInstructions += "\n ID: \(need.id) Need: \(need.name) \n"
        }
        
        var itemsInstructions = "\n Items: "
        
        for item in items {
            itemsInstructions += "\n ID: \(item.id) Name: \(item.name) \n"
        }
        
        return preamble + needsInstructions + itemsInstructions
    }
    
    /// Given a list of receipt lines scanned, return a detailed instruction set for an MCP agent to follow to extract pantry item data from the receipt.
    public static func generateItemsFromReceiptInstructions(lines: [String]) -> String {
        let preamble = "Use the MCP tool provided to create pantry items based on the receipt lines. Each line may contain the item name, quantity, weight, and price. Parse each line carefully to extract this information accurately, use inference where neccessary, some product names might be abbreviated heavily, use the context to infer them if possible. Fix obvious product name errors."
        
        var instructions = "\n Receipt lines: "
        
        // iterate over each line to be parsed and send to the agent
        for line in lines {
            instructions += "\n \(line)"
        }
        
        return preamble + instructions
    }
    
    /// Given a decoded product from OpenFoodFacts, return a detailed instruction set for an MCP agent to follow to extract pantry item data for the product.
    public static func generateItemFromBarcodeInstructions(data: OFFProduct) -> String {
        let preamble = "Use the MCP tool provided to create a pantry item based on product data. Infer the values of required fields if the data is missing."
        
        return preamble + data.formatForLLM()
    }
}

