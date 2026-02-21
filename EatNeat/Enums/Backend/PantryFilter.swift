//
//  PantryFilter.swift
//  EatNeat
//
//  Created by Oscar Horner on 14/02/2026.
//
// Represents a single filter that the user can apply to their items, such as [ "is" "perishable" ] or [ "expires in" ">" "7 days" ]

import Foundation

enum PantryFilter: Identifiable, Hashable {

    case expiresIn(Comparison, FilterTimeInterval)
    case age(Comparison, FilterTimeInterval)
    case isOpened(Bool)
    case isPerishable(Bool)

    var id: String {
        switch self {
        case .expiresIn(let c, let d):
            return "expires_\(c)_\(d)"
        case .age(let c, let d):
            return "age_\(c)_\(d)"
        case .isOpened(let v):
            return "opened_\(v)"
        case .isPerishable(let v):
            return "perishable_\(v)"
        }
    }
}

extension PantryFilter {

    var displayText: String {
        switch self {
        case .expiresIn(let comp, let time):
            return "Expires in \(comp.asString) \(time.asString)"

        case .age(let comp, let time):
            return "In pantry for \(comp.asString) \(time.asString)"

        case .isOpened(let value):
            return "Is: " + (value ? "Opened" : "Unopened")

        case .isPerishable(let value):
            return "Is: " + (value ? "Perishable" : "Non-Perishable")
        }
    }
}

extension PantryFilter {

    func matches(_ item: PantryItem) -> Bool {
        switch self {

        case .expiresIn(let comparison, let duration):
            guard let expiryDate = item.expiry else { return false }
            let diffSeconds = expiryDate.timeIntervalSinceNow

            switch comparison {
            case .lessThan:
                return diffSeconds < Double((duration.unit.secondsMultiplier * duration.amount))
            case .greaterThan:
                return diffSeconds > Double((duration.unit.secondsMultiplier * duration.amount))
            }

        case .age(let comparison, let duration):
            let diffSeconds = item.dateAdded.timeIntervalSinceNow

            switch comparison {
            case .lessThan:
                return diffSeconds < Double((duration.unit.secondsMultiplier * duration.amount))
            case .greaterThan:
                return diffSeconds > Double((duration.unit.secondsMultiplier * duration.amount))
            }

        case .isOpened(let value):
            return item.isOpened == value

        case .isPerishable(let value):
            return item.isPerishable == value
        }
    }
}

/// When the type is boolean, we need to be specific as to what the boolean is encoding.
enum BooleanFilterOption: CaseIterable, Identifiable {
    case opened
    case unopened
    case perishable
    case nonPerishable

    var id: Self { self }

    var displayName: String {
        switch self {
        case .opened: return "Opened"
        case .unopened: return "Unopened"
        case .perishable: return "Perishable"
        case .nonPerishable: return "Non-Perishable"
        }
    }

    var asPantryFilter: PantryFilter {
        switch self {
        case .opened:
            return .isOpened(true)
        case .unopened:
            return .isOpened(false)
        case .perishable:
            return .isPerishable(true)
        case .nonPerishable:
            return .isPerishable(false)
        }
    }
}
