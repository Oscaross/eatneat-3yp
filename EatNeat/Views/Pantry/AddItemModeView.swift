//
//  AddItemPickerView.swift
//  EatNeat
//
//  Created by Oscar Horner on 06/02/2026.
//

import SwiftUI

struct AddItemModeView: View {

    let onSelect: (AddItemMode) -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 12) {
            Spacer(minLength: 8)
            
            pickerRow(
                icon: "doc.text.viewfinder",
                title: "Scan receipt",
                subtitle: "Add multiple items at once"
            ) {
                select(.receipt)
            }

            pickerRow(
                icon: "barcode.viewfinder",
                title: "Scan barcode",
                subtitle: "Quick single-item scan"
            ) {
                select(.barcode)
            }

            pickerRow(
                icon: "pencil",
                title: "Add manually",
                subtitle: "Enter item details yourself"
            ) {
                select(.manual)
            }
            
            pickerRow(
                icon: "rectangle.stack",
                title: "Organise items",
                subtitle: "Clear out or update existing items"
            ) {
                select(.organise)
            }
            
            Spacer(minLength: 8)
        }
        .padding(.horizontal)
        .presentationDetents([.height(UIScreen.main.bounds.height * 0.4)])
        .presentationDragIndicator(.visible)
    }

    private func select(_ mode: AddItemMode) {
        onSelect(mode)
        dismiss()
    }
}

private extension AddItemModeView {

    func pickerRow(
        icon: String,
        title: String,
        subtitle: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 14) {

                Image(systemName: icon)
                    .font(.system(size: 22, weight: .semibold))
                    .frame(width: 36, height: 36)
                    .foregroundStyle(.blue)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(Color.blue.opacity(0.12))
                    )

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.body.weight(.semibold))
                        .foregroundStyle(.primary)

                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color(.secondarySystemBackground))
            )
        }
        .buttonStyle(.plain)
    }
}
