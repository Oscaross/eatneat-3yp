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
        let url = "https://slightly-decorating-hart-glen.trycloudflare.com/sse"
        let authUrl = "https://dev-ihzw0efrdvoarqax.us.auth0.com"

        transport.oauthConfiguration = OAuthConfiguration(
            issuer: URL(string: "\(authUrl)/")!,
            authorizationEndpoint: URL(string: "\(authUrl)/authorize")!,
            tokenEndpoint: URL(string: "\(authUrl)/oauth/token")!,
            introspectionEndpoint: URL(string: "\(authUrl)/userinfo")!,
            jwksEndpoint: URL(string: "\(authUrl)/.well-known/jwks.json")!,
            audience: url,
            clientID: "7by3qGnszksYNkWfJ8aAjS85IIC8cExd",
            clientSecret: "08zxa3DEakzCEqv1H3DOP1gR8FsiozKU0OXel2mOcXQrPEGtEZc6rJ6-_vlmrZcJ",
            transparentProxy: true
        )

        transport.authorizationHandler = { _ in .authorized }

        print("OAuth configured:", transport.oauthConfiguration != nil)
        try await transport.run()
    }


    
    
    // --- MCP Tools ---
    
    @MCPTool
    public func matchInventory(itemOwned : String, foodbankMatch : String, foodbankName : String) {
        MatchInventoryTool.matchInventory(itemOwned: itemOwned, foodbankMatch: foodbankMatch, foodbankName: foodbankName)
    }
}
