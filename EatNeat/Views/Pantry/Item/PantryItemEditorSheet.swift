//
//  PantryItemEditorSheet.swift
//  EatNeat
//
//  Created by Oscar Horner on 31/01/2026.
//
// Sheet that allows users to edit and add new PantryItems. Wraps the existing ItemView in a sheet with the correct toolbar buttons (ie. add vs update) and delete only if the item exists.

import SwiftUI

struct PantryItemEditorSheet: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var pantryVM: PantryViewModel
    
    @State private var banner: ActivityBanner?

    let sheet: PantryEditorSheet

    @State private var draft: PantryItem
    var onUpdate: (() -> Void)?

    init(sheet: PantryEditorSheet, pantryVM: PantryViewModel) {
        self.sheet = sheet
        self.pantryVM = pantryVM

        switch sheet {
        case .add:
            _draft = State(initialValue: PantryItem(
                name: "",
                category: .uncategorised,
                quantity: 1,
                weightQuantity: nil,
                weightUnit: .grams,
                isOpened: false,
                isPerishable: false,
                expiry: nil,
                cost: nil
            ))

        case .edit(let item):
            _draft = State(initialValue: item)
        }
    }

    var body: some View {
        NavigationStack {
            PantryItemView(
                item: $draft,
                pantryVM: pantryVM,
                mode: sheetMode,
                onDelete: {
                    pantryVM.removeItem(itemID: draft.id)
                    dismiss()
                }
            )
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button(actionTitle) {
                        commit()
                    }
                }
            }
        }
    }

    private var sheetMode: PantryItemView.Mode {
        switch sheet {
        case .add: return .add
        case .edit: return .edit
        }
    }

    private var actionTitle: String {
        switch sheet {
        case .add:  return "Save"
        case .edit: return "Update"
        }
    }

    private func commit() {
        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()

        switch sheet {
        case .add:
            pantryVM.addItem(item: draft)

        case .edit(let original):
            pantryVM.updateItem(
                updatedItem: draft
            )
        }

        dismiss()
    }
    
    private func undoLastAction() {
        pantryVM.addItem(item: draft)
    }
}
