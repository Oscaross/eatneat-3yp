//
//  SupermarketRegex.swift
//  EatNeat
//
//  Created by Oscar Horner on 28/01/2026.
//
// Represents global and supermarket-specific regex patterns for receipt parsing. The blacklist removes lines outright and the stoplist halts parsing the rest of the receipt to save tokens.

import Foundation

enum SupermarketRegex {

    static let tescoBlacklist: [NSRegularExpression] = [
        re(#"(?i)\b(clubcard|club card|cc\b|cc savings?|clubcard price|clubcard points?)\b"#)
    ]

    static let globalBlacklist: [NSRegularExpression] = [
        re(#"(?i)\b(merchant|authori[sz]ation|approved|approval)\b"#),
        re(#"(?i)\b(mastercard|visa|debit|credit|contactless)\b"#),
        re(#"(?i)\bhttps?:\/\/\S+|www\.\S+\b"#),
        re(#"\b\d{1,2}[\/\-]\d{1,2}[\/\-]\d{2,4}\b"#),
        re(#"\b\d{1,2}:\d{2}(:\d{2})?\b"#),
        re(#"(?i)\b(superstore|express|extra|metro)\b"#),
        re(#"(?i)\bVAT\b.*\b\d{3}\s?\d{3}\s?\d{2}\b"#),
        re(#"\b\d{8,}\b"#),
        re(#"\b[A-F0-9]{8,}\b"#)
    ]

    static let globalStopAfter: [NSRegularExpression] = [
        re(#"(?i)\b(subtotal|total|balance|amount due|change due|vat summary)\b"#)
    ]

    private static func re(_ pattern: String) -> NSRegularExpression {
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            fatalError("Invalid regex: \(pattern)")
        }
        return regex
    }
}
