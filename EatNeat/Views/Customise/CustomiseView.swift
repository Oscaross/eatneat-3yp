//
//  CustomiseView.swift
//  EatNeat
//
//  Created by Oscar Horner on 03/12/2025.
//
// Allow the user to customise app settings and tailor features to their own system such as item labels.

import SwiftUI

struct CustomiseView: View {
    @State private var showAddLabelSheet = false

    // Sample data only
    @State private var labels: [(name: String, color: Color)] = [
        ("Priority", .red),
        ("Half Eaten", .orange),
        ("Low Stock", .blue),
        ("For Donation", .green)
    ]

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(labels.indices, id: \.self) { index in
                        HStack(spacing: 12) {
                            // Colour indicator (pill-style, no icons)
                            RoundedRectangle(cornerRadius: 4)
                                .fill(labels[index].color)
                                .frame(width: 8, height: 32)

                            Text(labels[index].name)
                                .font(.body)

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                        .contentShape(Rectangle())
                    }
                    .onDelete { offsets in
                        labels.remove(atOffsets: offsets)
                    }

                    Button {
                        showAddLabelSheet = true
                    } label: {
                        Label("Add Label", systemImage: "plus")
                    }
                } header: {
                    Text("Custom Labels")
                } footer: {
                    Text("Labels can be applied to items such as “Priority”, “Half Eaten”, or “Low Stock”.")
                }
            }
            .navigationTitle("Customise")
            .sheet(isPresented: $showAddLabelSheet) {
                AddLabelSheet()
            }
        }
    }
}
