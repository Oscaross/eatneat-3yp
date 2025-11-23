//
//  main.swift
//  EatNeatMCP
//
//  Created by Oscar Horner on 18/11/2025.
//
// Temporary MCP server definition to spool up locally.

import Foundation
import SwiftMCP
import Dispatch

@MCPServer(name: "EatNeatMCP")
class EatNeatMCP {

    /// Sends a popup command into the EatNeat AppBridge.
    @MCPTool(
        description: "Show a popup notification inside the EatNeat app."
    )
    func showPopup(message: String) async throws -> [String: String] {

        let payload: [String: Any] = [
            "action": "showPopup",
            "message": message
        ]

        try await postToAppBridge(payload: payload)

        return [
            "status": "sent",
            "echo": message
        ]
    }
    

    @MCPTool(
        description: """
        Register a match between a user's pantry item and a foodbank need. \
        Call this when you decide an item closely matches a need. \
        Do NOT map the same item to more than one need.
        """
    )
    func registerItemNeedMatch(itemId: Int, needId: Int) async throws -> [String: Any] {
        let payload: [String: Any] = [
            "action": "registerItemNeedMatch",
            "itemId": itemId,
            "needId": needId
        ]

        try await postToAppBridge(payload: payload)

        return [
            "status": "ok",
            "itemId": itemId,
            "needId": needId
        ]
    }

    private func postToAppBridge(payload: [String: Any]) async throws {
        // DEV MODE: app inside Simulator on same machine
        guard let url = URL(string: "http://127.0.0.1:9090") else {
            throw NSError(domain: "MCP", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid AppBridge URL"])
        }

        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try JSONSerialization.data(withJSONObject: payload)

        // Perform POST
        let (_, response) = try await URLSession.shared.data(for: req)

        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw NSError(domain: "MCP", code: 2, userInfo: [NSLocalizedDescriptionKey: "AppBridge returned non-200 status"])
        }
    }
}

// Top-level entry point for the MCP executable.
let server = EatNeatMCP()
let transport = StdioTransport(server: server)

Task {
    do {
        try await transport.run()
        // If the transport returns, exit normally
        exit(0)
    } catch {
        fputs("MCP server error: \(error)\n", stderr)
        exit(1)
    }
}

dispatchMain()
