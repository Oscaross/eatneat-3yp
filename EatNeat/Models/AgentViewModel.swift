//
//  AgentViewModel.swift
//  EatNeat
//
//  Created by Oscar Horner on 28/11/2025.
//
// Encapsulates logic for processing and sending an AI-powered request from any part of the app.
// Reaches ChatGPT, ensuring that the correct data and MCP tools are passed to the agent so that the correct tools are then called to AppBridge.
// See https://github.com/MacPaw/OpenAI?tab=readme-ov-file#mcp-tool-integration

import Foundation
import SwiftUI
import MCP
import OpenAI

@MainActor
class AgentViewModel : ObservableObject {
    /// Ask the model to use the EatNeat MCP tools to satisfy `instructions`.
    /// We don't care about the text reply, only the tool calls.
    /// Tool is an instance of `MCPTool` enum which defines which tool the model is expected to use for the task. The instructions is a string which will be sent to the model and is a full description of the task at hand.
    public func triggerMCPTool(tool: MCPTool, instructions: String, pantryViewModel: PantryViewModel, donationViewModel: DonationViewModel) async throws {
        print("MCP tool triggered! Instructions: " + instructions)
        
        let configuration = OpenAI.Configuration(
            token: Secrets.openAIApiKey,
            timeoutInterval: 60
        )
        
        let openAI = OpenAI(configuration: configuration)
        
        // Build chat request
        let query = ChatQuery(
            messages: [
                .user(.init(content: .string(instructions)))
            ],
            model: .gpt4_o_mini,
            tools: [try await generateMCPTool(tool: .matchItemToNeeds)]
        )

        let result = try await openAI.chats(query: query)

        if let message = result.choices.first?.message {
            print("Model response text:", message.content ?? "<no text>")

            guard let toolCalls = message.toolCalls else {
                print("No tool calls in this response")
                return
            }

            for toolCall in toolCalls {

                // Only handle function-type tools
                guard toolCall.type == .function else { continue }

                // Extract the function call (not optional!)
                let function = toolCall.function

                // Only handle our specific tool
                guard function.name == "matchItemToNeeds" else { continue }

                do {
                    // Decode JSON arguments string
                    let data = Data(function.arguments.utf8)
                    let args = try JSONDecoder().decode(MatchItemToNeedsArgs.self, from: data)

                    // Look up the PantryItem
                    guard let item = pantryViewModel.getItemByID(itemID: args.itemId) else {
                        print("No pantry item with id \(args.itemId)")
                        continue
                    }

                    // Retrieve the foodbank
                    guard var fb = donationViewModel.foodbanks[args.foodbankId] else {
                        print("No foodbank with id \(args.foodbankId)")
                        continue
                    }

                    // Apply the match
                    fb.registerMatch(needId: args.needId, item: item)

                    // Save updated foodbank back into VM
                    donationViewModel.foodbanks[args.foodbankId] = fb

                } catch {
                    print("Error decoding arguments:", error)
                }
            }
        }
    }
    
    
    /// Queries the cloud-hosted MCP server for all tool definitions and selects the correct one based on the enum value
    private func generateMCPTool(tool: MCPTool) async throws -> ChatQuery.ChatCompletionToolParam {
        let mcpClient = MCP.Client(name: "EatNeat", version: "1.0.0")

        let mcpToken = "1f027ae8c4cf84ac352e0d6f15cbeb9b10cec553643e28d98fd405690b6565f1" // should maybe be obfuscated in Secrets but not that important

        let httpConfig = URLSessionConfiguration.default
        httpConfig.httpAdditionalHeaders = [
            "Authorization": "Bearer \(mcpToken)"
        ]

        let transport = HTTPClientTransport(
            endpoint: URL(string: "https://eatneat-mcp.onrender.com/mcp")!,
            configuration: httpConfig
        )

        _ = try await mcpClient.connect(transport: transport)
        let toolsResponse = try await mcpClient.listTools()
        
        switch(tool) {
        case .matchItemToNeeds:
            return ChatQuery.ChatCompletionToolParam(
                function: .init(
                    name: "matchItemToNeeds",
                    description: "Registers a matching from a pantry item to a foodbank need. All IDs are coded.",
                    parameters: makeMatchItemToNeedsSchema(),
                    strict: false
                )
            )
        }
    }
    
    // DEV: MacPaw library for some reason doesn't compile it's own code supplied in the README (???)
    /// For now, this is a temporary workaround that generates our MCP schema locally and sends it to ChatGPT.
    private func makeMatchItemToNeedsSchema() -> JSONSchema {
        let raw: [String: Any] = [
            "type": "object",
            "properties": [
                "itemId": ["type": "string"],
                "needId": ["type": "integer"],
                "foodbankId": ["type": "string"]
            ],
            "required": ["itemId", "needId", "foodbankId"]
        ]

        do {
            let data = try JSONSerialization.data(withJSONObject: raw, options: [])
            let schema = try JSONDecoder().decode(JSONSchema.self, from: data)
            return schema
        } catch {
            fatalError("Failed to build JSONSchema for matchItemToNeeds: \(error)")
        }
    }

}

enum MCPTool {
    case matchItemToNeeds
}

struct MatchItemToNeedsArgs: Decodable {
    let foodbankId: String
    let needId: Int
    let itemId: UUID
}
