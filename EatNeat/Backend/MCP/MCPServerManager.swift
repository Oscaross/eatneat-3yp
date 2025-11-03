//
//  McpServerManager.swift
//  EatNeat
//
//  Created by Oscar Horner on 29/10/2025.
//
// Core MCP server management class. Ensures the MCP server is configured and all tools are compliant + exposed to the agent.
// When adding a connector, use ngrok http 8080 --host-header=rewrite to get a public URL that can be accessed by ChatGPT.

import SwiftMCP
import MCP
import Foundation

@MCPServer
actor MCPServerManager {
    // -- Configuration --
    
    func startServer() async throws {
        let transport = HTTPSSETransport(server: self, host: "0.0.0.0", port: 8080)
        try await transport.run()
    }
    
    // --- MCP Tools ---
    
    @MCPTool
    public func matchInventory(itemOwned : String, foodbankMatch : String, foodbankName : String) {
        MatchInventoryTool.matchInventory(itemOwned: itemOwned, foodbankMatch: foodbankMatch, foodbankName: foodbankName)
    }
}
