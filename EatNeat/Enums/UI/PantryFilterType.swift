//
//  PantryFilterType.swift
//  EatNeat
//
//  Created by Oscar Horner on 14/02/2026.
//
// Defines precisely how a user is allowed to create a PantryFilter, what fields they need for each type of filter and the types of filter allowed.

enum PantryFilterType: CaseIterable, Identifiable {
    case expiresIn
    case age
    case boolean

    var id: Self { self }
}

extension PantryFilterType {

    var isBoolean: Bool {
        return self == .boolean
    }

    var requiresComparison: Bool {
        switch self {
        case .expiresIn, .age:
            return true
        default:
            return false
        }
    }

    var requiresParameter: Bool {
        switch self {
        case .expiresIn, .age:
            return true
        default:
            return false
        }
    }
    
    var asString: String {
        switch self {
        case .expiresIn:
            return "Expires in"
        case .age:
            return "In pantry for"
        case .boolean:
            return "Is"
        }
    }
}
