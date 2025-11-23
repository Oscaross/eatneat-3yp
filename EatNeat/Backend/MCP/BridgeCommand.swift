//
//  BridgeCommand.swift
//  EatNeat
//
//  Created by Oscar Horner on 22/11/2025.
//
// Defines the data model for commands sent from the MCP server to the app through AppBridge.

import Foundation

enum BridgeCommand: Codable, Identifiable {
    case showPopup(id: UUID, message: String)
    case matchItemToNeed(id: UUID, foodbankID: String, needID: Int, itemID: UUID)

    var id: UUID {
        switch self {
        case .showPopup(let id, _),
             .matchItemToNeed(let id, _, _, _):
            return id
        }
    }
}

