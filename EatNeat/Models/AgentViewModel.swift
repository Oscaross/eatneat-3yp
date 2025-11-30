//
//  AIRequest.swift
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

@MainActor
class AgentViewModel {
    let openAI = OpenAI(apiToken: "YOUR_TOKEN_HERE") // Model initialization with API key
    
    public func triggerMCPTool(instructions: String) async throws {
        // Connect to MCP server using the MCP Swift library
        let mcpClient = MCP.Client(name: "EatNeat", version: "1.0.0")

        let transport = HTTPClientTransport(
            endpoint: URL(string: "https://api.githubcopilot.com/mcp/")!, // TODO: cloud hosted MCP server through Render
            configuration: URLSessionConfiguration.default
        )

        let result = try await mcpClient.connect(transport: transport)
        let toolsResponse = try await mcpClient.listTools()

        // Create OpenAI MCP tool with discovered tools
        let enabledToolNames = toolsResponse.tools.map { $0.name }
        let mcpTool = Tool.mcpTool(
            .init(
                _type: .mcp,
                serverLabel: "EatNeat_MCP",
                serverUrl: "https://api.githubcopilot.com/mcp/", // TODO: cloud hosted MCP server through Render
                headers: .init(), // TODO: Add auth headers
                allowedTools: .case1(enabledToolNames),
                requireApproval: .case2(.always)
            )
        )

        // Use in chat completion
        let query = ChatQuery(
            messages: [.user(.init(content: .string("Help me search GitHub repositories")))],
            model: .gpt4_o_mini,
            tools: [mcpTool]
        )

        let chatResult = try await openAI.chats(query: query)
    }
}
