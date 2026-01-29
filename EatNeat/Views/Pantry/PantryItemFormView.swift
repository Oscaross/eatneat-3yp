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
    
    var body: some View {

        // MARK: Details section
        Section(header: Text("Details")) {
            HStack {
                TextField("Item Name", text: $item.name)
                Spacer()
                
                if let label = item.label {
                    CapsuleView(text: label.name, color: label.color) { }
                } else {
                    CapsuleView(text: "...", color: .gray) { }
                }
            }

            HStack {
                Menu {
                    ForEach(Category.allCases) { category in
                        Button(category.rawValue) {
                            item.category = category
                        }
                    }
                } label: {
                    Text(item.category.rawValue)
                }
            }
                
            HStack {
                CapsuleToggleView(
                    value: $item.isPerishable,
                    trueLabel: "Perishable",
                    falseLabel: "Non-perishable",
                    color: .gray
                )
                .padding(.all, 4)
                
                Spacer()

                CapsuleToggleView(
                    value: $item.isOpened,
                    trueLabel: "Opened",
                    falseLabel: "Unopened",
                    color: .gray
                )
                .padding(.all, 4)
            }
        }

        // MARK: Stock section
        Section(header: Text("Stock")) {
            HStack(alignment: .center, spacing: 16) {

                // LEFT: Weight + Unit
                HStack {
                    TextField("0.0",
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

                // RIGHT: Quantity
                HStack(spacing: UIScreen.main.bounds.width * 0.04) {

                    if qtyFieldFocused {
                        TextField("",
                                  value: $item.quantity,
                                  format: .number
                        )
                        .keyboardType(.numberPad)
                        .frame(width: 40)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(.roundedBorder)
                        .focused($qtyFieldFocused)
                        .onChange(of: item.quantity) { _ in
                            item.quantity = min(max(item.quantity, 1), 99)
                        }

                    } else {
                        Text("\(item.quantity)")
                            .fontWeight(.medium)
                            .onTapGesture {
                                qtyFieldFocused = true
                            }
                    }

                    Stepper("",
                            value: $item.quantity,
                            in: 1...99
                    )
                    .labelsHidden()
                }
            }
            .frame(height: UIScreen.main.bounds.height * 0.05)
        }

        // MARK: Other section eg. cost, expiry
        Section(header: Text("Other")) {

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
    }
}
