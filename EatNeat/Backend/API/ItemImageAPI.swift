//
//  ItemImageAPI.swift
//  EatNeat
//
//  Created by Oscar Horner on 11/02/2026.
//
// Queries OpenFoodFacts for a product image URL that the application can display.

import Foundation

final class ItemImageAPI {
    
    /// Searches the OpenFoodFacts API and returns a matching image of the product from a front-view angle
    public static func getProductImageURL(productName: String) async throws -> URL? {
        print("Trying to get the product image URL for \(productName)")
        
        let urlString = "https://world.openfoodfacts.org/api/v0/product/\(productName).json"
        guard let url = URL(string: urlString) else { return nil }

        let (data, _) = try await URLSession.shared.data(from: url)

        let decoded = try JSONDecoder().decode(OFFResponse.self, from: data)

        guard var ret = decoded.product?.imageFrontURL else {
            return nil // no product URL was found
        }
        
        return URL(string: ret)
    }
}

