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

    // Available colours
    private let labelColors: [Color] = [
        .red,
        .orange,
        .yellow,
        .green,
        .mint,
        .teal,
        .blue,
        .indigo,
        .purple,
        .pink
    ]

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 5)

    // State
    @State private var labelName: String = ""
    @State private var selectedColor: Color = .blue

    var body: some View {
        NavigationStack {
            Form {
                // Name
                Section {
                    TextField("Label name", text: $labelName)
                }

                // Colour picker
                Section(header: Text("Label colour")) {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(labelColors, id: \.self) { color in
                            Circle()
                                .fill(color)
                                .frame(width: 36, height: 36)
                                .overlay(
                                    Circle()
                                        .stroke(
                                            color == selectedColor
                                                ? Color.primary
                                                : .clear,
                                            lineWidth: 3
                                        )
                                )
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.15)) {
                                        selectedColor = color
                                    }
                                    UIImpactFeedbackGenerator(style: .light)
                                        .impactOccurred()
                                }
                                .accessibilityLabel(color.description)
                                .accessibilityAddTraits(
                                    color == selectedColor ? .isSelected : []
                                )
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("New Label")
            .toolbar {
                // Cancel
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                // Save
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveLabel()
                        dismiss()
                    }
                    .disabled(labelName.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }

    private func saveLabel() {
        // TODO: Actually make it save
        UINotificationFeedbackGenerator()
            .notificationOccurred(.success)
    }
}
