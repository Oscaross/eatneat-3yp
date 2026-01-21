//
//  Handler.swift
//  EatNeat
//
//  Created by Oscar Horner on 17/01/2026.
//
// Callback function for the register new item MCP tool

import OpenAI
import Foundation

struct RegisterNewItemHandler: MCPToolHandler {
    let tool: MCPTool = .registerNewItem
    let schema: JSONSchema = MCPSchemas.registerNewItem()
    let description: String = "Registers a new item into the user's pantry."

    func handle(
        args: RegisterNewItemArgs,
        context: AgentContext
    ) throws {
        print("Trying to register a new item!")
        // let unit = args.weightType.flatMap { WeightUnit(rawValue: $0) }

        let item = PantryItem(
            name: args.itemName,
            category: Category.biscuitsSnacksAndConfectionery, // TODO: Implement this enum in the schema generation
            quantity: args.quantity,
            weightUnit: WeightUnit.grams, // TODO: Implement this enum too
            isOpened: false,
            expiry: args.expiry,
            cost: args.price,
            dateAdded: Date()
        )

        context.pantry.addItem(item: item)
    }
}
