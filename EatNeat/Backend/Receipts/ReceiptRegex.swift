//
//  ReceiptRegex.swift
//  EatNeat
//
//  Created by Oscar Horner on 28/01/2026.
//
// Returns the appropriate regex rules for a given supermarket receipt.

import Foundation

final class ReceiptRegex {

    static func rules(for supermarket: Supermarket?) -> ReceiptRules {
        switch supermarket {
        case .tesco:
            return ReceiptRules(
                blacklist: SupermarketRegex.tescoBlacklist
                         + SupermarketRegex.globalBlacklist,
                stopAfter: SupermarketRegex.globalStopAfter
            )
        default:
            return ReceiptRules(
                blacklist: SupermarketRegex.globalBlacklist,
                stopAfter: SupermarketRegex.globalStopAfter
            )
        }
    }
}
