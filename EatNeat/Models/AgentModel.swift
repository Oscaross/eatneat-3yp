//
//  AgentViewModel.swift
//  EatNeat
//
//  Created by Oscar Horner on 28/11/2025.
//
// Encapsulates logic for processing and sending an AI-powered request from any part of the app.
// Reaches ChatGPT, ensuring that the correct data and MCP tools are passed to the agent so that the correct tools are then called to AppBridge.
// See https://github.com/MacPaw/OpenAI?tab=readme-ov-file#mcp-tool-integration
//


import Foundation
import MCP
import OpenAI

@MainActor
final class AgentModel: ObservableObject {
    private let openAI = OpenAI(
        configuration: .init(token: Secrets.openAIApiKey, timeoutInterval: 60)
    )

    func triggerMCPTool<H: MCPToolHandler>(
        handler: H,
        instructions: String,
        context: AgentContext
    ) async throws {

        let query = ChatQuery(
            messages: [.user(.init(content: .string(instructions)))],
            model: .gpt4_o,
            tools: [try await generateMCPTool(from: handler)]
        )

        let result = try await openAI.chats(query: query)
        guard let toolCalls = result.choices.first?.message.toolCalls else { return }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        for call in toolCalls where call.type == .function {
            guard call.function.name == handler.tool.rawValue else { continue }

            let data = Data(call.function.arguments.utf8)
            let args = try decoder.decode(H.Args.self, from: data)

            try handler.handle(args: args, context: context)
        }
    }

    private func generateMCPTool<H: MCPToolHandler>(
        from handler: H
    ) async throws -> ChatQuery.ChatCompletionToolParam {

        let mcpClient = MCP.Client(name: "EatNeat", version: "1.0.0")

        let httpConfig = URLSessionConfiguration.default
        httpConfig.httpAdditionalHeaders = [
            "Authorization": "Bearer \(Secrets.mcpEndpointBearerToken)"
        ]

        let transport = HTTPClientTransport(
            endpoint: URL(string: Secrets.mcpEndpoint)!,
            configuration: httpConfig
        )

        _ = try await mcpClient.connect(transport: transport)

        return ChatQuery.ChatCompletionToolParam(
            function: .init(
                name: handler.tool.rawValue,
                description: handler.description,
                parameters: handler.schema,
                strict: false
            )
        )
    }
}
