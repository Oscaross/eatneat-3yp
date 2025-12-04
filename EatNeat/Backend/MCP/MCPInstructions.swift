//
//  Instructions.swift
//  EatNeat
//
//  Created by Oscar Horner on 04/12/2025.
//
// This class handles the building of detailed instructions objects for agents to use as MCP requests. For each MCP tooling, there is a corresponding request function.

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
}

