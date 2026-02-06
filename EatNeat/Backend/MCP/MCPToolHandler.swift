//
//  MCPToolHandler.swift
//  EatNeat
//
//  Created by Oscar Horner on 17/01/2026.
//
// Protocol that defines a handler for a specific tool. The handler makes sure the correct function is called by the LLM and deals with all of its arguments.
// It also defines the presence of pantry and donation view models so object persistence occurs.

import Foundation
import OpenAI

protocol MCPToolHandler {
    associatedtype Args: Decodable

    var tool: MCPTool { get }
    var schema: JSONSchema { get }
    var description: String { get }

    @MainActor
    func handle(
        args: Args,
        context: AgentContext
    ) throws
}

