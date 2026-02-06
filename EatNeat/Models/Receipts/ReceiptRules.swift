//
//  ReceiptRules.swift
//  EatNeat
//
//  Created by Oscar Horner on 28/01/2026.
//
// Holds regex for stoplist and blacklists, used when parsing receipts.

import Foundation

struct ReceiptRules {
    let blacklist: [NSRegularExpression] // detected => remove the line that matches
    let stopAfter: [NSRegularExpression] // detected => stop parsing the receipt
}
