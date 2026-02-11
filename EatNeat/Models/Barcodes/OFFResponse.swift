//
//  OFFResponse.swift
//  EatNeat
//
//  Created by Oscar Horner on 11/02/2026.
//
// Represents a response from the OpenFoodFacts API, status code and the product data

struct OFFResponse: Decodable {
    let status: Int
    let product: OFFProduct?
}
