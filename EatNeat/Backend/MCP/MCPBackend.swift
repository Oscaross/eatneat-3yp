//
//  MCP.swift
//  EatNeat
//
//  Created by Oscar Horner on 26/10/2025.
//
// Used for the handling, sending and exposing of messages to ChatGPT through the MCP

import MCP
import Foundation

struct MCPBackend {
    /// Fetches needs of nearby foodbanks, takes the list of the user's digital pantry and executes the logic for displaying a popup telling them what food matches the local needs.
    public static func pollNearbyFoodbanks() async throws {
        let client = Client(name: "EatNeat", version: "1.0.0")
        let transport = HTTPClientTransport(
            endpoint: URL(string: "http://localhost:8080")!,
            streaming: true
        )
        try await client.connect(transport: transport)
        print("Client connected!")
        
        let (tools, _) = try await client.listTools()
        print("Available tools: \(tools.map(\.name))")
    }

}
