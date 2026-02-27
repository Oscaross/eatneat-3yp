//
//  FoodbankCard.swift
//  EatNeat
//
//  Created by Oscar Horner on 26/02/2026.
//
// Data model representing the information within a foodbank card in the Donation viewer

import Foundation

struct FoodbankCard: Identifiable, Hashable {

    // MARK: - Identity
    let id: String
    let name: String

    // MARK: - Location
    let distanceMeters: Double?
    let distanceText: String

    // MARK: - Meta
    let needsLastUpdated: Date?
    let needsLastUpdatedText: String?
    let isFavourite: Bool

    // MARK: - Needs
    let needs: [Need]
    let surpluses: [String] // excess the foodbank doesn't need i.e. "Baked Beans"

    // MARK: - Ranked Prompts
    let donationPrompts: [DonationPromptDisplay]

    var hasPrompts: Bool {
        !donationPrompts.isEmpty
    }
}

struct DonationPromptDisplay: Identifiable, Hashable {

    // Stable composite ID: "\(foodbankID)-\(needID)-\(itemID)"
    let id: String

    // MARK: - Need
    let needID: UUID
    let needName: String

    // MARK: - Item
    let itemID: UUID
    let itemName: String

    // MARK: - Explanation Signals
    let behaviouralScore: Double
    let semanticScore: Double
    let finalScore: Double
}
