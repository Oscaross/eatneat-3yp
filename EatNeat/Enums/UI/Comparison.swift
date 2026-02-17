//
//  Comparison.swift
//  EatNeat
//
//  Created by Oscar Horner on 14/02/2026.
//
// Allows users to manage filtering by saying if they want a property less than or greater than

enum Comparison: String, CaseIterable, Identifiable {
    case lessThan
    case greaterThan

    var id: String { rawValue }

    var asString: String {
        switch self {
        case .lessThan: return "<"
        case .greaterThan: return ">"
        }
    }
}
