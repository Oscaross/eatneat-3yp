//
//  ItemLabel.swift
//  EatNeat
//
//  Created by Oscar Horner on 27/11/2025.
//
// Allows a user to do custom tagging on an item (such as "Priority", "Half Eaten", "Low Stock")

import SwiftUI

struct ItemLabel: Identifiable, Hashable, Codable {
    let id: UUID
    let name: String
    let color: Color

    // Store color as RGBA
    private enum CodingKeys: CodingKey {
        case id, name, red, green, blue, opacity
    }

    init(id: UUID = UUID(), name: String, color: Color) {
        self.id = id
        self.name = name
        self.color = color
    }

    // MARK: Codable
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)

        let red   = try container.decode(Double.self, forKey: .red)
        let green = try container.decode(Double.self, forKey: .green)
        let blue  = try container.decode(Double.self, forKey: .blue)
        let opacity = try container.decode(Double.self, forKey: .opacity)

        color = Color(red: red, green: green, blue: blue, opacity: opacity)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)

        // Extract RGBA components
        let uiColor = UIColor(color)

        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

        try container.encode(Double(red),   forKey: .red)
        try container.encode(Double(green), forKey: .green)
        try container.encode(Double(blue),  forKey: .blue)
        try container.encode(Double(alpha), forKey: .opacity)
    }
}

