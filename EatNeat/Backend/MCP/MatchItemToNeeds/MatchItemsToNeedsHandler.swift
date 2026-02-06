//
//  Handler.swift
//  EatNeat
//
//  Created by Oscar Horner on 17/01/2026.
//
// Callback function for the match item to needs MCP tool

import OpenAI

struct MatchItemToNeedsHandler: MCPToolHandler {
    let tool: MCPTool = .matchItemToNeeds
    let schema: JSONSchema = MCPSchemas.matchItemToNeeds()
    let description: String = "Matches an item from the pantry to a foodbank's need."

    @MainActor
    func handle(
        args: MatchItemToNeedsArgs,
        context: AgentContext
    ) throws {
        print("Trying to register a new item match!")
        guard let item = context.pantry.getItemByID(itemID: args.itemId) else { return }
        guard var fb = context.donation.foodbanks[args.foodbankId] else { return }

        fb.registerMatch(needId: args.needId, item: item)
        context.donation.foodbanks[args.foodbankId] = fb
    }
}
