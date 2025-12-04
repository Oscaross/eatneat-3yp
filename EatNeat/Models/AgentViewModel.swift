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
import MCP
import OpenAI

class AgentViewModel : ObservableObject {
    /// Ask the model to use the EatNeat MCP tools to satisfy `instructions`.
    /// We don't care about the text reply, only the tool calls.
    func triggerMCPTool(instructions: String) async throws {
        print("MCP tool triggered! Instructions: " + instructions)
        
        let configuration = OpenAI.Configuration(
            token: Secrets.openAIApiKey,
            timeoutInterval: 60
        )
        
        let openAI = OpenAI(configuration: configuration)
        
        
        do {
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
            
            let matchItemToNeedsTool = ChatQuery.ChatCompletionToolParam(
                function: .init(
                    name: "matchItemToNeeds",
                    description: "Registers a matching from a pantry item to a foodbank need. All IDs are coded.",
                    parameters: makeMatchItemToNeedsSchema(),
                    strict: false
                )
            )

            // Build chat request
            let query = ChatQuery(
                messages: [
                    .user(.init(content: .string("Call the match foodbank MCP function on foodbankID 1, itemID 2 and needID 1."))) // TODO: Make real message
                ],
                model: .gpt4_o_mini,
                tools: [matchItemToNeedsTool]
            )

            let result = try await openAI.chats(query: query)

            // We don’t care about the textual reply, this is for debugging:
            if let message = result.choices.first?.message {
                print("Model response text:", message.content ?? "<no text>")
                if let toolCalls = message.toolCalls {
                    print("Model proposed tool calls:", toolCalls)
                } else {
                    print("No tool calls in this response")
                }
            }
        
        } catch {
            print("triggerMCPTool error:", error)
        }
    }
    
    // DEV: MacPaw library for some reason doesn't compile it's own code supplied in the README (???)
    /// For now, this is a temporary workaround that generates our MCP schema locally and sends it to ChatGPT.
    func makeMatchItemToNeedsSchema() -> JSONSchema {
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
