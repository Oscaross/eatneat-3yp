//
//  Preferences.swift
//  EatNeat
//
//  Created by Oscar Horner on 06/02/2026.
//
// The storage location and flag for user-set preferences.

enum Preferences {

    enum Pantry {
    }

    enum Donation {
        static let enableSuggestions = Preference<Bool>(
            key: "pref.donation.enableSuggestions",
            defaultValue: true
        )
    }

    enum Scanning {
    }

    enum Appearance {
        static let useSystemTheme = Preference<Bool>(
            key: "pref.appearance.useSystemTheme",
            defaultValue: true
        )
    }
}
