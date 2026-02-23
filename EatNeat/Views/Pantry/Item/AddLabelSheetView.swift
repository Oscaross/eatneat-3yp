//
//  AddLabelSheetView.swift
//  EatNeat
//
//  Created by Oscar Horner on 21/02/2026.
//
// A view to allow users to add a new custom label with a name and a color preference

import SwiftUI

struct AddLabelSheetView: View {
    @State private var name: String = ""
    @State private var color: Color

    private var onAdd: (String, Color) -> Void
    private var onDismiss: () -> Void

    private let availableColors = AppStyle.labelColors
    private let maxChars = AppConstants.MAX_LABEL_LENGTH_CHARS

    init(
        onAdd: @escaping (String, Color) -> Void,
        onDismiss: @escaping () -> Void
    ) {
        self.color = availableColors.first ?? .teal
        self.onAdd = onAdd
        self.onDismiss = onDismiss
    }

    private var trimmedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var canAdd: Bool {
        !trimmedName.isEmpty
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {

                HStack(spacing: 10) {
                    // More "system" looking field without excessive width
                    TextField("Label name…", text: $name)
                        .textInputAutocapitalization(.words)
                        .autocorrectionDisabled()
                        .submitLabel(.done)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .overlay {
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .strokeBorder(.quaternary, lineWidth: 1)
                        }
                        .frame(maxWidth: 220, alignment: .leading) // prevents weird full-width stretch
                        .onChange(of: name) { _, newValue in
                            // enforce max 8 chars
                            if newValue.count > maxChars {
                                name = String(newValue.prefix(maxChars))
                            }
                        }

                    CapsuleMenu<Color>(
                        title: "Color",
                        selection: $color,
                        options: availableColors,
                        display: { $0.description.localizedCapitalized },
                        color: color
                    )
                }

                // Optional but nice: subtle character count feedback
                HStack {
                    Spacer()
                    Text("\(min(trimmedName.count, maxChars))/\(maxChars)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 10)
            .navigationTitle("New Label")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        onDismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        onAdd(trimmedName, color)
                        onDismiss()
                    }
                    .disabled(!canAdd)
                }
            }
        }
        .presentationDetents([.height(UIScreen.main.bounds.height * 0.15)])
    }
}
