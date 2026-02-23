//
//  Constants.swift
//  EatNeat
//
//  Created by Oscar Horner on 20/10/2025.
//
// Defines global app constants for certain tunable parts of functionality, such as how far the foodbank search algorithm runs in km or how long users are allowed to make labels in characters.

import SwiftUI

enum AppConstants {
    static let MAX_ITEM_QUANTITY: Int = 50
    static let FOODBANK_SEARCH_RADIUS_KM: Double = 10
    static let BANNER_TIMEOUT_SECONDS: Double = 4
    static let MAX_LABEL_LENGTH_CHARS: Int = 10
}
