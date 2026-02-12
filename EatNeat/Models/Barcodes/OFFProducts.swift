//
//  OFFProducts.swift
//  EatNeat
//
//  Created by Oscar Horner on 12/02/2026.
//
// Allows us to decode a series of products rather than just one

import Foundation

struct OFFProducts: Decodable {
    let products: [OFFProduct]
}
