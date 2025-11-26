//
//  PantryItemView.swift
//  EatNeat
//
//  Created by Oscar Horner on 20/10/2025.
//

import SwiftUI

struct PantryItemView: View {
    @Environment(\.dismiss) private var dismiss // handle dialog sheet dismissal
    
    var pageTitle: String {
        switch mode {
        case .add:
            return "Add Item"
        case .edit:
            return "Edit Item"
        }
    }

    let mode: ItemViewMode
    
    init(mode: ItemViewMode) {
        self.mode = mode

        switch mode {
        case .add:
            break
        case .edit(let item):
            _name = State(initialValue: item.name)
            _selectedCategory = State(initialValue: item.category)
            _quantity = State(initialValue: item.quantity)
            _isOpened = State(initialValue: item.isOpened)
            _weight = State(initialValue: item.weightQuantity)
            _weightUnit = State(initialValue: item.weightUnit ?? .grams) // default to grams if none is given
            _expiry = State(initialValue: item.expiry)
            _cost = State(initialValue: item.cost)
        }
    }
    
    // Non-optional variables -> user has to select these for the item to be added
    @State private var name = ""
    @State private var selectedCategory: Category = .none
    @State private var quantity: Int = 1
    @State private var isOpened: Bool = false
    
    // Optional variables -> may be left blank, but allow for functionality
    @State private var weight: Double? = nil
    @State private var weightUnit: WeightUnit = .grams
    @State private var expiry: Date? = nil
    @State private var cost: Double? = nil
    

    @FocusState private var qtyFieldFocused: Bool // allow user to tap qty number or use stepper
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Details")) {
                    TextField("Item Name", text: $name)
                    
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(Category.allCases, id: \.self) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                    
                    Toggle("Opened", isOn: $isOpened.animation())
                    
                }
                Section(header: Text("Stock")) {
                    HStack(alignment: .center, spacing: 16) {

                        // LEFT: Weight input
                        HStack {
                            TextField("0.0", value: $weight, format: .number)
                                .keyboardType(.decimalPad)
                                .frame(width: 70)
                                .textFieldStyle(.roundedBorder)

                            Picker("", selection: $weightUnit) {
                                ForEach(WeightUnit.allCases, id: \.self) { unit in
                                    Text(unit.rawValue).tag(unit)
                                }
                            }
                            .pickerStyle(.menu)
                            .frame(maxWidth: 60, alignment: .leading)
                        }

                        Spacer()

                        // RIGHT: Quantity Stepper
                        HStack(spacing: UIScreen.main.bounds.width * 0.04) {

                            if qtyFieldFocused {
                                // Editable text field mode
                                TextField("", value: $quantity, format: .number)
                                    .keyboardType(.numberPad)
                                    .frame(width: 40)
                                    .multilineTextAlignment(.center)
                                    .textFieldStyle(.roundedBorder)
                                    .focused($qtyFieldFocused)
                                    .onChange(of: quantity) {
                                        quantity = min(max(quantity, 1), 99)
                                    }

                            } else {
                                // Normal label mode (tappable to edit)
                                Text("\(quantity)")
                                    .fontWeight(.medium)
                                    .onTapGesture {
                                        qtyFieldFocused = true
                                    }
                            }

                            Stepper("", value: $quantity, in: 1...99)
                                .labelsHidden()
                        }
                    }
                    .frame(height: UIScreen.main.bounds.height * 0.05)
                }


                Section(header: Text("Other")) {

                    // EXPIRY DATE
                    HStack {
                        Text("Expiry")

                        Spacer()

                        DatePicker(
                            "",
                            selection: Binding(
                                get: { expiry ?? Date() },
                                set: { expiry = $0 }
                            ),
                            displayedComponents: .date
                        )
                        .datePickerStyle(.compact)
                    }
                    
                    // COST FIELD
                    HStack {
                        Text("Cost")
                        
                        Spacer()
                        
                        HStack {
                            Text("£")
                                .foregroundColor(.secondary)
                            
                            TextField("0.00", value: $cost, format: .number)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                                .frame(width: 70)
                        }
                    }
                }
                
                if case .edit(let item) = mode {
                    Section {
                        Button(role: .destructive) {
                            dismiss()
                        } label: {
                            Text("Delete Item")
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
            }
            .navigationTitle(pageTitle)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    switch mode {
                    case .add:
                        Button("Save") {  }
                    case .edit:
                        Button("Update") {  }
                    }
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}

enum ItemViewMode {
    case add
    case edit(existing: PantryItem)
}

enum WeightUnit: String, CaseIterable, Codable {
    case grams = "g"
    case kilograms = "kg"
    case pounds = "lbs"
    case millilitres = "ml"
    case litres = "l"
}
