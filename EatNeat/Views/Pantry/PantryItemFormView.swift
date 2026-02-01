//
//  PantryItemFormView.swift
//  EatNeat
//
//  Created by Oscar Horner on 28/12/2025.
//
// Allows users to edit and view stored pantry item properties. Works on new instances (no data) or existing instances (eg. from scanner).

import SwiftUI

struct PantryItemFormView: View {
    @Binding var item: PantryItem

    @FocusState private var qtyFieldFocused: Bool

    let availableLabels: [ItemLabel]
    @State private var selectedLabels: Set<ItemLabel> = []

    var body: some View {

        // DETAILS
        Section(header: Text("Details")) {

            // Name + label capsule
            HStack {
                TextField("Item Name", text: $item.name)
            }

            // CATEGORY — manual row (left-aligned)
            HStack {
                Picker("", selection: $item.category) {
                    ForEach(Category.allCases, id: \.self) { category in
                        Text(category.rawValue).tag(category)
                    }
                }
                .labelsHidden()
                .pickerStyle(.menu)

                Spacer()
            }
            .contentShape(Rectangle()) // full-row tap
            
            HStack {
                CapsuleToggleView(
                    value: $item.isPerishable,
                    trueLabel: "Perishable",
                    falseLabel: "Non-perishable",
                    color: .gray
                )

                Spacer()

                CapsuleToggleView(
                    value: $item.isOpened,
                    trueLabel: "Opened",
                    falseLabel: "Unopened",
                    color: .gray
                )
            }
        }

        // STOCK
        Section(header: Text("Stock")) {
            HStack(alignment: .center, spacing: 16) {

                // Weight + unit
                HStack {
                    TextField(
                        "0.0",
                        value: Binding(
                            get: { item.weightQuantity },
                            set: { item.weightQuantity = $0 }
                        ),
                        format: .number
                    )
                    .keyboardType(.decimalPad)
                    .frame(width: 70)
                    .textFieldStyle(.roundedBorder)

                    Picker("", selection: Binding(
                        get: { item.weightUnit ?? .grams },
                        set: { item.weightUnit = $0 }
                    )) {
                        ForEach(WeightUnit.allCases, id: \.self) { unit in
                            Text(unit.rawValue).tag(unit)
                        }
                    }
                    .pickerStyle(.menu)
                    .frame(maxWidth: 60, alignment: .leading)
                }

                Spacer()

                // Quantity
                HStack(spacing: UIScreen.main.bounds.width * 0.04) {
                    if qtyFieldFocused {
                        TextField(
                            "",
                            value: $item.quantity,
                            format: .number
                        )
                        .keyboardType(.numberPad)
                        .frame(width: 40)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(.roundedBorder)
                        .focused($qtyFieldFocused)
                        .onChange(of: item.quantity) { _, _ in
                            item.quantity = min(max(item.quantity, 1), 99)
                        }
                    } else {
                        Text("\(item.quantity)")
                            .fontWeight(.medium)
                            .onTapGesture {
                                qtyFieldFocused = true
                            }
                    }

                    Stepper("", value: $item.quantity, in: 1...99)
                        .labelsHidden()
                }
            }
        }

        // OTHER
        Section(header: Text("Other")) {

            // Expiry
            HStack {
                Text("Expiry")
                Spacer()

                DatePicker(
                    "",
                    selection: Binding(
                        get: { item.expiry ?? Date() },
                        set: { item.expiry = $0 }
                    ),
                    displayedComponents: .date
                )
                .datePickerStyle(.compact)
            }

            // Cost
            HStack {
                Text("Cost")
                Spacer()

                HStack {
                    Text("£")
                        .foregroundColor(.secondary)

                    TextField(
                        "0.00",
                        value: Binding(
                            get: { item.cost },
                            set: { item.cost = $0 }
                        ),
                        format: .number
                    )
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 70)
                }
            }
        }
        
        Section(
            header: HStack {
                Text(
                    selectedLabels.isEmpty
                    ? "LABELS"
                    : "LABELS (\(selectedLabels.count))"
                )
                Spacer()

                if !selectedLabels.isEmpty {
                    ClearButtonView(action: { selectedLabels.removeAll() })
                }
            }
            .textCase(nil) // prevent clear button being all caps
        ) {
            LabelBarView(
                availableLabels: availableLabels,
                selectedLabels: $selectedLabels,
                allowsMultipleSelection: true
            )
            .onChange(of: selectedLabels) { _, newValue in
                for label in newValue {
                    item.toggleLabel(_: label)
                }
            }
        }
    }
}
