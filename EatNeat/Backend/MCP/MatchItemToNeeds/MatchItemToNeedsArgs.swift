//
//  MatchItemToNeedsArgs.swift
//  EatNeat
//
//  Created by Oscar Horner on 16/01/2026.
//

import Foundation

struct MatchItemToNeedsArgs: Decodable {
    let foodbankId: String
    let needId: Int
    let itemId: UUID
}
