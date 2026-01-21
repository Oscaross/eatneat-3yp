//
//  RegisterNewItemArgs.swift
//  EatNeat
//
//  Created by Oscar Horner on 16/01/2026.
//
// Arguments for the RegisterNewItem MCP endpoint to function.

import Foundation

struct RegisterNewItemArgs: Decodable {
    let itemName: String
    let category: Int
    let quantity: Int
    let weight: Double?
    let weightType: Int?
    let price: Double?
    let expiry: Date?
}
