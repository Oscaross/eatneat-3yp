//
//  PantryItemView.swift
//  EatNeat
//
//  Created by Oscar Horner on 20/10/2025.
//

import SwiftUI

struct PantryItemView: View {

    /// Draft item owned by the parent (sheet, organiser, etc.)
    @Binding var item: PantryItem

    let availableLabels: [ItemLabel]

    /// Editing context (purely for UI differences)
    let mode: Mode
    var onDelete: (() -> Void)? = nil

    enum Mode {
        case add
        case edit
        case editNoDelete
    }

    var body: some View {
        Form {
            PantryItemFormView(item: $item, availableLabels: availableLabels)

            if mode == .edit {
                Section {
                    Button(role: .destructive) {
                        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                        onDelete?()
                    } label: {
                        Text("Delete Item")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
        }
    }
    
    private func undoLastAction() -> Void {
    }
}
