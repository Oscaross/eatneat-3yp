//
//  WeightUnit.swift
//  EatNeat
//
//  Created by Oscar Horner on 28/12/2025.
//

enum WeightUnit: String, CaseIterable, Codable {
    case grams = "g"
    case kilograms = "kg"
    case pounds = "lbs"
    case millilitres = "ml"
    case litres = "l"
    case none = ""
}

extension WeightUnit {
    /// Stable LLM/wire code
    var code: Int {
        switch self {
        case .grams: return 0
        case .kilograms: return 1
        case .pounds: return 2
        case .millilitres: return 3
        case .litres: return 4
        case .none: return 5
        }
    }
    /// Get a stable weight unit from its code.
    static func from(code: Int) -> WeightUnit {
        switch code {
        case 0: return .grams
        case 1: return .kilograms
        case 2: return .pounds
        case 3: return .millilitres
        case 4: return .litres
        default: return .none
        }
    }
}
