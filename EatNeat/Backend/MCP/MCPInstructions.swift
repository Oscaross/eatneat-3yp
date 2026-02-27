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

