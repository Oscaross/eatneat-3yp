//
//  FilterSheetView.swift
//  EatNeat
//
//  Created by Oscar Horner on 13/02/2026.
//
// A generic sheet to allow the user to control their filter options for viewing a set of PantryItem

import SwiftUI

struct FilterSheetView: View {
    let pantryVM: PantryViewModel

    // Local editable copy
    @State private var filter: PantryFilterSet

    // Label state
    @State private var selectedLabels: Set<ItemLabel>

    // Category state
    @State private var lastSelectedCategory: Category
    @State private var selectedCategories: [Category]
    @State private var shouldIncludeCategories: Bool
    private let pillColumns = [
        GridItem(.adaptive(minimum: 90), spacing: 8, alignment: .leading)
    ]

    // Attribute state
    @State private var selectedFilters: [PantryFilter]
    @State private var showAddAttributeSheet: Bool = false

    let onApply: (PantryFilterSet) -> Void
    let onCancel: () -> Void

    init(
        pantryVM: PantryViewModel,
        filter: PantryFilterSet,
        onApply: @escaping (PantryFilterSet) -> Void,
        onCancel: @escaping () -> Void
    ) {
        self.pantryVM = pantryVM
        self.onApply = onApply
        self.onCancel = onCancel

        _filter = State(initialValue: filter)

        _selectedFilters = State(initialValue: filter.attributeFilters)
        _selectedLabels = State(initialValue: Set(filter.labelFilters))

        _shouldIncludeCategories = State(initialValue: filter.includeCategories)
        _selectedCategories = State(initialValue: filter.categoryFilters)

        _lastSelectedCategory = State(initialValue: filter.categoryFilters.first ?? .homeBaking)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Form {
                    Section("Labels") {
                        LabelBarView(
                            pantryVM: pantryVM,
                            selectedLabels: $selectedLabels,
                            allowsMultipleSelection: true,
                            onAddLabel: {
                                print("User wants to add a label")
                            }
                        )
                    }

                    Section {
                        CapsuleMenu(
                            title: "Category",
                            options: Category.allCases.filter { !selectedCategories.contains($0) },
                            display: { $0.rawValue },
                            onConfirm: { category in
                                selectedCategories.append(category)
                            },
                            color: .gray,
                            label: {
                                AddButtonView(action: {})
                            }
                        )
                        FlowLayoutView(spacing: 8) {
                            ForEach(selectedCategories, id: \.self) { category in
                                PillView(
                                    text: category.rawValue,
                                    onTap: {
                                        selectedCategories.removeAll { $0 == category }
                                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    }
                                )
                            }
                        }
                        .padding(.vertical, 4)
                    } header: {
                        HStack {
                            Text("Categories")
                            Spacer()
                            CapsuleToggleView(
                                value: $shouldIncludeCategories,
                                trueLabel: .text("Include"),
                                falseLabel: .text("Exclude"),
                                color: .gray,
                                shouldChangeAppearanceOnToggle: false
                            )
                        }
                        .textCase(nil)
                    }

                    Section("Attributes") {
                        ForEach(selectedFilters.indices, id: \.self) { index in
                            let f = selectedFilters[index]
                            CapsuleView(
                                content: .text(f.displayText),
                                color: AppStyle.primary,
                                heavy: false,
                                action: { selectedFilters.remove(at: index) }
                            )
                        }

                        AddButtonView(
                            color: .gray,
                            action: { showAddAttributeSheet = true }
                        )
                    }
                }
                .navigationTitle("Filter Items")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Clear") {
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            // reset the filter to a default state
                            pantryVM.filter = .init()
                            onCancel()
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Apply") {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()

                            var updated = filter
                            updated.attributeFilters = selectedFilters
                            updated.categoryFilters = selectedCategories
                            updated.includeCategories = shouldIncludeCategories
                            updated.labelFilters = selectedLabels
                            updated.includeLabels = true

                            onApply(updated)
                        }
                    }
                }
                .sheet(isPresented: $showAddAttributeSheet) {
                    CreateFilterSheetView(
                        onCreate: { f in
                            selectedFilters.append(f)
                            showAddAttributeSheet = false
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        },
                        onDismiss: { showAddAttributeSheet = false }
                    )
                }
            }
        }
    }
}
