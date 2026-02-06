//
//  ActivityBanner.swift
//  EatNeat
//
//  Created by Oscar Horner on 03/02/2026.
//
// Generic description for an activity banner that represents things the user has just done like "Donate x to y" or "Remove x from my pantry", coupled with an action callback (primarly for undoing said action).

import SwiftUI

struct ActivityBanner: Identifiable, Equatable {
    let id = UUID()
    let message: String
    let actionTitle: String?
    let action: (() -> Void)?
    
    static func == (lhs: ActivityBanner, rhs: ActivityBanner) -> Bool {
        return lhs.id == rhs.id
    }
}

