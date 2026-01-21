//
//  Secrets.swift
//  EatNeat
//
//  Created by Oscar Horner on 30/11/2025.
//
// Extract values stored in Secrets.plist such as the API key for OpenAI or the MCP endpoint.

import Foundation

enum Secrets {
    // Load plist once
    private static let plist: [String: Any] = {
        guard
            let url = Bundle.main.url(forResource: "Secrets", withExtension: "plist"),
            let data = try? Data(contentsOf: url),
            let dict = try? PropertyListSerialization.propertyList(
                from: data,
                options: [],
                format: nil
            ) as? [String: Any]
        else {
            fatalError("Secrets.plist not found or unreadable")
        }
        return dict
    }()

    static var openAIApiKey: String {
        guard let key = plist["OPENAI_API_KEY"] as? String else {
            fatalError("OPENAI_API_KEY missing from Secrets.plist")
        }
        return key
    }

    static var mcpEndpoint: String {
        guard let endpoint = plist["MCP_ENDPOINT"] as? String else {
            fatalError("MCP_ENDPOINT missing from Secrets.plist")
        }
        return endpoint
    }

    static var mcpEndpointBearerToken: String {
        guard let token = plist["MCP_ENDPOINT_BEARER_TOKEN"] as? String else {
            fatalError("MCP_ENDPOINT_BEARER_TOKEN missing from Secrets.plist")
        }
        return token
    }
}
