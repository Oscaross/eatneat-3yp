//
//  SupermarketRegex.swift
//  EatNeat
//
//  Created by Oscar Horner on 23/01/2026.
//
// Represents common/known patterns for UK supermarkets to help trim irrelevant data.

import Foundation

final class SupermarketRegex {

    /// Pattern for a specific supermarket
    static func getRegex(for supermarket: Supermarket) -> String {
        switch supermarket {
        case .tesco:
            return #"(?i)(clubcard|subtotal|vat number)"#
        }
        
        // TODO: Also append the global regex to the specific regex 
    }

    /// Global pattern applying to most receipts
    private static func getRegexGlobal() -> String {
        return #"(?i)(total|change due|card payment|thank you)"#
    }
}


