//
//  ClearButtonView.swift
//  EatNeat
//
//  Created by Oscar Horner on 01/02/2026.
//
// A shorthand for a clear button used in multiple views.

import SwiftUI

struct ClearButtonView: View {
    let action: () -> Void // callback for whatever is cleared
    
    init(
        action: @escaping () -> Void
    ) {
        self.action = action
    }
    
    var body: some View {
        CapsuleView(text: "Clear", color: .red, heavy: false, action: {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            action()
        })
    }
}

