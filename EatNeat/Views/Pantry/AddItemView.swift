//
//  AddItemView.swift
//  EatNeat
//
//  Created by Oscar Horner on 20/10/2025.
//

import SwiftUI

struct AddItemView: View {
    @ObservedObject var viewModel: PantryViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var selectedCategory: Category = .none
    @State private var quantity: Int = 1
    @State private var weight: Double? = 0.0 // nullable
    @State private var metric: Bool = true // metric vs imperial
    @State private var stockLevel: Double = 100 // what % of the item is left

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("New Item")) {
                    HStack {
                        RequiredFieldLabel(text: "Name")
                            .frame(width: 70, alignment: .leading)

                        Spacer()

                        TextField("...", text: $name)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 180, height: 34, alignment: .trailing)
                    }
                    HStack {
                        RequiredFieldLabel(text: "Category")
                        Picker("", selection: $selectedCategory) {
                            ForEach(Category.allCases, id: \.self) { category in
                                Text(category.rawValue.capitalized)
                            }
                        };
                    }
                }
                Section(header: Text("Item Details")) {
                    // Quantity row
                    HStack(alignment: .firstTextBaseline) {
                        RequiredFieldLabel(text: "Qty")
                            .frame(width: 70, alignment: .leading)

                        Spacer()

                        HStack(spacing: 8) {
                            Button(action: {
                                HapticFeedback.hapticImpact(intensity: .light)
                                quantity -= (quantity > 0) ? 1 : 0
                            }) {
                                Image(systemName: "minus.circle.fill")
                                    .foregroundColor(.red.opacity(0.8))
                                    .font(.system(size: 22))
                            }

                            TextField("", value: $quantity, format: .number)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.center)
                                .frame(width: 50, height: 34)
                                .textFieldStyle(RoundedBorderTextFieldStyle())

                            Button(action: {
                                HapticFeedback.hapticImpact(intensity: .light)
                                quantity += (quantity <= AppConstants.MAX_ITEM_QUANTITY) ? 1 : 0
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(AppStyle.accentBlue)
                                    .font(.system(size: 22))
                            }
                        }
                    }

                    // Weight row
                    HStack(alignment: .firstTextBaseline) {
                        Text("Weight")
                            .frame(width: 70, alignment: .leading)

                        Spacer()

                        HStack(spacing: 8) {
                            TextField("0", value: $weight, format: .number)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.center)
                                .frame(width: 70, height: 34)
                                .textFieldStyle(RoundedBorderTextFieldStyle())

                            Button(action: {
                                HapticFeedback.hapticImpact(intensity: .light)
                                toggleWeightUnit()
                            }) {
                                Text(metric ? "grams" : "lbs")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(AppStyle.accentBlue)
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
                Section(header: Text("Stock Level")) {
                    Text("Placeholder")
                }
            }
            .navigationTitle("Add Item")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        // all weights are stored in grams for simplicity
                        if (!metric) {
                            toggleWeightUnit()
                        }
                            
                        viewModel.addItem(name: name, category: selectedCategory, weight: weight)
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
    
    /// Dynamically converts weight state variable between metric or imperial depending on the chosen preference.
    private func toggleWeightUnit() {
        guard let w = weight else {
            metric.toggle()
            return
        }

        if metric {
            // Convert gram -> lbs
            weight = (w / 1000) * 2.205
        } else {
            // Convert lbs -> gram
            weight = (w / 2.205) * 1000
        }
        metric.toggle()
    }
}
