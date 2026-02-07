//
//  AddItemMode.swift
//  EatNeat
//
//  Created by Oscar Horner on 06/02/2026.
//
// Represents the different routes a user can take to add items to their pantry

enum AddItemMode: Identifiable {
    case receipt
    case barcode
    case manual

    var id: Self { self }
}
