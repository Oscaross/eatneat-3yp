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
        return nil
        
        print("Trying to get the product image URL for \(productName)")

        var components = URLComponents(string: "https://world.openfoodfacts.org/cgi/search.pl")!

        components.queryItems = [
            URLQueryItem(name: "search_terms", value: productName),
            URLQueryItem(name: "search_simple", value: "1"),
            URLQueryItem(name: "action", value: "process"),
            URLQueryItem(name: "json", value: "1"),
            URLQueryItem(name: "page_size", value: "10"),
            URLQueryItem(name: "fields", value: "product_name,product_name_en,generic_name,generic_name_en,brands,image_front_url"),

            // UK filter
            URLQueryItem(name: "tagtype_0", value: "countries"),
            URLQueryItem(name: "tag_contains_0", value: "contains"),
            URLQueryItem(name: "tag_0", value: "en:united-kingdom")
        ]

        guard let url = components.url else { return nil }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let http = response as? HTTPURLResponse,
              200..<300 ~= http.statusCode else {
            return nil
        }

        let decoded = try JSONDecoder().decode(OFFProducts.self, from: data)

        // Prefer best name match first
        let searchLower = productName.lowercased()

        let sorted = decoded.products.sorted {
            let lhsMatch = $0.displayName?.lowercased().contains(searchLower) ?? false
            let rhsMatch = $1.displayName?.lowercased().contains(searchLower) ?? false
            return lhsMatch && !rhsMatch
        }

        for product in sorted {
            if let imageString = product.imageFrontURL,
               let imageURL = URL(string: imageString) {
                return imageURL
            }
        }

        return nil
    }


}

