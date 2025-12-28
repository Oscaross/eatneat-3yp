//
//  PantryItemView.swift
//  EatNeat
//
//  Created by Oscar Horner on 20/10/2025.
//
import SwiftUI

enum ItemViewMode {
    case add
    case edit(existing: PantryItem)
}

struct PantryItemView: View {
    @ObservedObject var pantryViewModel: PantryViewModel
    @Environment(\.dismiss) private var dismiss

    let mode: ItemViewMode
    let availableLabels: [ItemLabel]

    // The working copy the form edits
    @State private var item: PantryItem

    // For updates we still need to know which item ID to update
    private let originalID: UUID?

    var pageTitle: String {
        switch mode {
        case .add:  return "Add Item"
        case .edit: return "Edit Item"
        }
    }

    init(
        mode: ItemViewMode,
        availableLabels: [ItemLabel] = [
            ItemLabel(name: "New",          color: .teal),
            ItemLabel(name: "Half Eaten",   color: .green),
            ItemLabel(name: "Almost Empty", color: .orange),
            ItemLabel(name: "Large",        color: .red),
            ItemLabel(name: "Use",          color: .purple),
            ItemLabel(name: "Stale",        color: .mint)
        ],
        viewModel: PantryViewModel
    ) {
        self.mode = mode
        self.availableLabels = availableLabels
        self.pantryViewModel = viewModel

        switch mode {
        case .add:
            _item = State(initialValue: PantryItem(
                name: "",
                category: .none,
                quantity: 1,
                weightQuantity: nil,
                weightUnit: .grams,
                isOpened: false,
                expiry: nil,
                cost: nil
            ))
            self.originalID = nil

        case .edit(let existing):
            // Start with the existing item as the working copy
            _item = State(initialValue: existing)
            self.originalID = existing.id
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                PantryItemFormView(item: $item)

                if isEditing {
                    Section {
                        Button(role: .destructive) {
                            deleteItem()
                        } label: {
                            Text("Delete Item")
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
            }
            .navigationTitle(pageTitle)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(isEditing ? "Update" : "Save") {
                        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                        handleSaveOrUpdate()
                    }
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }

    private var isEditing: Bool {
        if case .edit = mode { return true } else { return false }
    }

    private func handleSaveOrUpdate() {
        switch mode {
        case .add:
            pantryViewModel.addItem(item: item)

        case .edit:
            guard let originalID else {
                assertionFailure("Missing originalID in edit mode")
                return
            }
            pantryViewModel.updateItem(itemID: originalID, updatedItem: item)
        }

        dismiss()
    }

    private func deleteItem() {
        if case .edit(let existing) = mode {
            pantryViewModel.removeItem(item: existing)
            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            dismiss()
        }
    }
}
