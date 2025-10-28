//
//  HapticFeedback.swift
//  EatNeat
//
//  Created by Oscar Horner on 22/10/2025.
//

import SwiftUI

struct HapticFeedback {
    /// Triggers the device to create Haptic Feedback based on the intensity value.
    public static func hapticImpact(intensity: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: intensity)
        generator.impactOccurred()
    }
}

