//
//  FilterSheetView.swift
//  EatNeat
//
//  Created by Oscar Horner on 13/02/2026.
//
// A generic sheet to allow the user to control their filter options for viewing a set of PantryItem

import SwiftUI

struct FilterSheetView: View {
    @EnvironmentObject var pantryVM: PantryViewModel
    
    
    // MARK: Label state
    @State private var selectedLabels: Set<ItemLabel> = []
    
    // MARK: Category state
    @State private var lastSelectedCategory: Category = Category.homeBaking
    @State private var selectedCategories: [Category] = []
    @State private var shouldIncludeCategories: Bool = true // false = EXCLUDE categories

    // MARK: Attribute State
    @State private var selectedFilters: [PantryFilter]
    @State private var showAddAttributeSheet: Bool = false
    

    let onApply: ([PantryFilter]) -> Void
    let onCancel: () -> Void

    init(filters: [PantryFilter],
         onApply: @escaping ([PantryFilter]) -> Void,
         onCancel: @escaping () -> Void) {
        self.onApply = onApply
        self.onCancel = onCancel
        self.selectedFilters = filters
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("LABELS") {
                    LabelBarView(
                        availableLabels: pantryVM.getUserLabels(),
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
                        selection: $lastSelectedCategory,
                        options: Category.allCases.filter {
                            !selectedCategories.contains($0) // only render categories that haven't been added to the filter
                        },
                        display: { $0.rawValue },
                        onConfirm: { category in
                            selectedCategories.append(category)
                        },
                        color: .gray,
                        label: {
                            AddButtonView(
                                action: {
                                    
                                }
                            )
                        }
                    )
                    
                    ForEach(selectedCategories) { category in
                        PillView(
                            text: category.rawValue
                        )
                    }
                } header: {
                    HStack {
                        Text("CATEGORIES")
                        Spacer()
                        // Include-exclude button
                        CapsuleToggleView(
                            value: $shouldIncludeCategories,
                            trueLabel: .text("Include"),
                            falseLabel: .text("Exclude"),
                            color: .gray,
                            shouldChangeAppearanceOnToggle: false
                        )
                    }
                    .textCase(nil) // stop include/exclude from being auto capitalised
                }

                Section("ATTRIBUTES") {
                    
                    // MARK: Render all active filters
                    ForEach(selectedFilters.indices, id: \.self) { index in
                        let filter = selectedFilters[index]

                        CapsuleView(
                            content: .text(filter.displayText),
                            color: AppStyle.primary,
                            heavy: false,
                            action: {
                                selectedFilters.remove(at: index) // if user taps a filter then we remove it
                            }
                        )
                    }
                    
                    // MARK: Add filter route
                    AddButtonView(
                        color: .gray,
                        action: {
                            showAddAttributeSheet = true
                        }
                    )
                }
            }
            .navigationTitle("Filter Items")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { onCancel() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Apply") { onApply(selectedFilters) }
                }
            }
            .sheet(isPresented: $showAddAttributeSheet) {
                CreateFilterSheetView(
                    onCreate: { filter in
                        selectedFilters.append(filter)
                        showAddAttributeSheet = false
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    },
                    onDismiss: {
                        showAddAttributeSheet = false
                    }
                )
            }
        }
    }
}
