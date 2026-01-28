//
//  AddLabelSheet.swift
//  EatNeat
//
//  Created by Oscar Horner on 26/01/2026.
//
// Allow users to add a new label with custom name and colour.

import SwiftUI

struct AddLabelSheet: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Label name", text: .constant(""))
                }

                Section {
                    ColorPicker("Label colour", selection: .constant(.blue))
                }
            }
            .navigationTitle("New Label")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
