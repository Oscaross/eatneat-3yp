//
//  MCPToolError.swift
//  EatNeat
//
//  Created by Oscar Horner on 16/01/2026.
//
// Raised when an MCP tool is called with invalid parameters

import Foundation

enum MCPToolError: Error {
    case badArguments(expected: String)
    case missingPantryItem(id: UUID)
    case missingFoodbank(id: String)
    case invalidEnumValue(field: String, value: Int)
}
