//
//  MCPSchemas.swift
//  EatNeat
//
//  Created by Oscar Horner on 20/01/2026.
// We must manually create JSON schemas for each tool. This is not ideal, but it's because of bugs with existing libraries. https://github.com/MacPaw/OpenAI/issues/389

import Foundation
import OpenAI

public enum MCPSchemas {
    static func matchItemToNeeds() -> JSONSchema {
        let raw: [String: Any] = [
            "type": "object",
            "properties": [
                "itemId": ["type": "string"],
                "needId": ["type": "integer"],
                "foodbankId": ["type": "string"]
            ],
            "required": ["itemId", "needId", "foodbankId"]
        ]

        let data = try! JSONSerialization.data(withJSONObject: raw, options: [])
        return try! JSONDecoder().decode(JSONSchema.self, from: data)
    }
    
    static func registerNewItem() -> JSONSchema {
        let userCategories = Category.allCases.map { $0.rawValue }
        
        var categoryDescription = "Category value as an ID. Possible values:\n"
        
        var i = 0
        
        for category in userCategories {
            categoryDescription += "\(i)- \(category):)\n"
            i+=1
        }
        
        let raw: [String: Any] = [
            "type": "object",
            "properties": [
                "itemName": [
                    "type": "string",
                    "description": "Human-readable name of the product. Limit to around 4 words and remove redundant branding or promotional text, only words that are important to describe the product."
                ],
                "category": [
                    "type": "integer",
                    "description": "Category value. Possible values: \(userCategories)"
                ],
                "quantity": [
                    "type": "integer",
                    "description": "Number of items purchased"
                ],
                "weight": [
                    "type": "number",
                    "description": "Weight or volume of the item (if applicable)"
                ],
                "weightType": [
                    "type": "integer",
                    "description": "WeightUnit enum raw value"
                ],
                "price": [
                    "type": "number",
                    "description": "Price paid for the item"
                ],
                "expiry": [
                    "type": "string",
                    "format": "date-time",
                    "description": "Expiry date in ISO-8601 format"
                ]
            ],
            "required": ["itemName", "category", "quantity"]
        ]

        let data = try! JSONSerialization.data(withJSONObject: raw, options: [])
        return try! JSONDecoder().decode(JSONSchema.self, from: data)
    }
}
