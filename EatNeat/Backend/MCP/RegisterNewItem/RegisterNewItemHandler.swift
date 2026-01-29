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
        print("Trying to register a new item: \(args.itemName)")
        
        let name = args.itemName
        let category = Category.from(index: args.category)
        let qty = args.quantity
        let weightQuantity = args.weight ?? 0.0
        let weightUnit = (args.weightType != nil) ?  WeightUnit.from(code: args.weightType!) : WeightUnit.none
        let expiry = args.expiry
        let cost = args.price
        let isPerishable = args.isPerishable
        let dateAdded = Date() // TODO: Could maybe let the user customise this but is it information overload?

        let item = PantryItem(
            name: name,
            category: category, 
            quantity: qty,
            weightQuantity: weightQuantity,
            weightUnit: weightUnit,
            isOpened: false,
            isPerishable: isPerishable,
            expiry: expiry,
            cost: cost,
            dateAdded: dateAdded
        )

        context.scannedItems!.append(item)
    }
}
