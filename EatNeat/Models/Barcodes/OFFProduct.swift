//
//  OFFProduct.swift
//  EatNeat
//
//  Created by Oscar Horner on 11/02/2026.
//
// Represents the decodable product taken from the OpenFoodFacts API.

struct OFFProduct: Decodable {
    let genericName: String?
    let genericNameEN: String?
    let abbreviatedProductName: String?
    let productNameEN: String?
    let productName: String?
    let categoriesTags: [String]?
    let quantity: String?
    let productQuantity: Double?
    let productQuantityUnit: String?
    let brands: String?
    let imageFrontURL: String?

    enum CodingKeys: String, CodingKey {
        case categoriesTags = "categories_tags"
        case quantity
        case productQuantity = "product_quantity"
        case productQuantityUnit = "product_quantity_unit"
        case brands
        case imageFrontURL = "image_front_url"
        case productName = "product_name"
        case productNameEN = "product_name_en"
        case genericName = "generic_name"
        case genericNameEN = "generic_name_en"
        case abbreviatedProductName = "abbreviated_product_name"
    }
}

extension OFFProduct {
    var displayName: String? {
        if let name = productName, !name.isEmpty {
            return name
        }

        if let generic = genericName, !generic.isEmpty {
            return generic
        }

        if let brand = brands, !brand.isEmpty {
            return brand
        }

        return nil
    }
}

extension OFFProduct {

    /// Returns a structured, LLM-friendly representation of the product.
    /// Only includes non-nil values.
    func formatForLLM() -> String {
        var lines: [String] = []

        if let name = displayName {
            lines.append("Name: \(name)")
        }

        if let brand = brands, !brand.isEmpty {
            lines.append("Brand: \(brand)")
        }

        if let quantity = quantity, !quantity.isEmpty {
            lines.append("Declared Quantity: \(quantity)")
        }

        if let amount = productQuantity,
           let unit = productQuantityUnit {
            lines.append("Structured Quantity: \(amount) \(unit)")
        }

        if let categories = categoriesTags,
           !categories.isEmpty {
            let cleaned = categories
                .map { $0.replacingOccurrences(of: "en:", with: "") }
                .joined(separator: ", ")
            lines.append("Categories: \(cleaned)")
        }

        if let imageURL = imageFrontURL {
            lines.append("Image URL: \(imageURL)")
        }

        if lines.isEmpty {
            return "No structured product data available."
        }

        return """
        OpenFoodFacts Product Data:
        \(lines.joined(separator: "\n"))
        """
    }
}
