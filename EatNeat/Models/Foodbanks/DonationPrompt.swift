//
//  DonationPrompt.swift
//  EatNeat
//
//  Created by Oscar Horner on 26/02/2026.
//
// Data model representing a match between a user item and a foodbank need.

import Foundation

struct DonationPrompt: Identifiable {
    var id: UUID
    var needID: UUID
    var itemRecordID: UUID // NOT referencing a PantryItem, this references a unique name for an item that a user has added to their pantry in the past
}

