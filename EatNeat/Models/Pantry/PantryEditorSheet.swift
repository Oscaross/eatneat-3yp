//
//  PantryEditorSheet.swift
//  EatNeat
//
//  Created by Oscar Horner on 31/01/2026.
//

import Foundation

enum PantryEditorSheet: Identifiable {
    case add
    case edit(PantryItem)

    var id: UUID {
        switch self {
        case .add:
            return UUID(uuidString: "00000000-0000-0000-0000-000000000001")!
        case .edit(let item):
            return item.id
        }
    }
}
