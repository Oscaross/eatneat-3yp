//
//  ImageSearchState.swift
//  EatNeat
//
//  Created by Oscar Horner on 11/02/2026.
//
// Manage the state for image URLs by holding the current status of our search for the corresponding image. inProgress helps prevent race conditions.

enum ImageSearchState: String, Codable {
    case notAttempted
    case inProgress
    case done
    case failed
}
