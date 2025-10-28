//
//  RequiredField.swift
//  EatNeat
//
//  Created by Oscar Horner on 21/10/2025.
//
// Shorthand UI element to create a red asterisk to indicate to the user that a field is non-nullable

import SwiftUI

struct RequiredFieldLabel: View {
    let text: String

    var body: some View {
        HStack(spacing: 2) {
            Text(text)
            Text("*")
                .foregroundColor(.red)
        }
        .accessibilityLabel("\(text), required")
    }
}
