//
//  Style.swift
//  EatNeat
//
//  Created by Oscar Horner on 18/10/2025.
//

import SwiftUI

enum AppStyle {
    // App-wide colors
    static let accentBlue = Color.blue.opacity(0.8)
    static let primary = Color.blue
    static let secondary = Color.indigo
    static let lightBlueBackground = Color.blue.opacity(0.08)
    static let containerBackground = Color(.systemGray6).opacity(0.1)
    
    // Text styles
    struct Text {
        static let sectionHeader = Font.system(.headline, weight: .bold)
        static let body = Font.system(.body)
    }
}
