//
//  PantryItemFormView.swift
//  EatNeat
//
//  Created by Oscar Horner on 28/12/2025.
//

import SwiftUI

struct PantryItemFormView: View {
    @Binding var item: PantryItem
    
    @FocusState private var qtyFieldFocused: Bool
    
    var body: some View {

        // DETAILS
        Section(header: Text("Details")) {
            TextField("Item Name", text: $item.name)

            Picker("Category", selection: $item.category) {
                ForEach(Category.allCases, id: \.self) { category in
                    Text(category.rawValue).tag(category)
                }
            }

            Toggle("Opened", isOn: $item.isOpened.animation())
        }

        // STOCK
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

        // OTHER
        Section(header: Text("Other")) {

            // EXPIRY
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

            // COST
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
