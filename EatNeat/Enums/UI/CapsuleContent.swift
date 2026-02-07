//
//  CapsuleContent.swift
//  EatNeat
//
//  Created by Oscar Horner on 06/02/2026.
//
// Represents the content of a clickable button capsule, which can be either text, an icon, or both.

enum CapsuleContent{
    case text(String)
    case icon(systemName: String)
    case textAndIcon(text: String, systemName: String)
    
    /// Support accessibility by providing a descriptive label for icons, text and a combination that screen readers can use.
    var accessibilityLabel: String {
        switch self {
        case .text(let text):
            return text

        case .icon(let systemName):
            return systemName
                .replacingOccurrences(of: ".", with: " ")
                .replacingOccurrences(of: "fill", with: "")
                .trimmingCharacters(in: .whitespaces)

        case .textAndIcon(let text, _):
            return text
        }
    }
}
