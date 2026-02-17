//
//  CreateFilterSheetView.swift
//  EatNeat
//
//  Created by Oscar Horner on 14/02/2026.
//
// Allows the user to compose a new attribute filter with the type, comparator and integer parameter.
// Example: ["Age" ">" "4 days"]

import SwiftUI

struct CreateFilterSheetView: View {

    @Environment(\.dismiss) private var dismiss

    let onCreate: (PantryFilter) -> Void
    let onDismiss: () -> Void

    @State private var type: PantryFilterType = .expiresIn
    @State private var comparison: Comparison = .lessThan
    @State private var duration = FilterTimeInterval(amount: 7, unit: .days)
    @State private var booleanOption: BooleanFilterOption = .opened

    var body: some View {
        NavigationStack {

            VStack(spacing: 14) {

                HStack(spacing: 10) {

                    CapsuleMenu(
                        title: "Filter Type",
                        selection: $type,
                        options: PantryFilterType.allCases,
                        display: { $0.asString }
                    )

                    switch type {

                    case .age, .expiresIn:
                        CapsuleMenu(
                            title: "Comparison",
                            selection: $comparison,
                            options: Comparison.allCases,
                            display: { $0.asString }
                        )

                        HStack(spacing: 10) {
                            Picker("Amount", selection: $duration.amount) {
                                ForEach(amountRange, id: \.self) { value in
                                    Text("\(value)").tag(value)
                                }
                            }
                            .pickerStyle(.wheel)
                            .frame(width: 80, height: 92)
                            .clipped()

                            CapsuleMenu(
                                title: "Unit",
                                selection: $duration.unit,
                                options: TimeUnit.allCases,
                                display: { $0.displayName(for: duration.amount) }
                            )
                        }

                    case .boolean:
                        CapsuleMenu(
                            title: "Property",
                            selection: $booleanOption,
                            options: BooleanFilterOption.allCases,
                            display: { $0.displayName }
                        )
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("New Filter")
            .navigationBarTitleDisplayMode(.inline)

            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        onDismiss()
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        onCreate(builtFilter)
                        dismiss()
                    }
                    .bold()
                }
            }
        }
        .presentationDetents([.height(sheetHeight)])
        .presentationDragIndicator(.visible)
    }
    

    private var builtFilter: PantryFilter {
        switch type {
        case .expiresIn:
            return .expiresIn(comparison, duration)
        case .age:
            return .age(comparison, duration)
        case .boolean:
            return booleanOption.asPantryFilter
        }
    }

    private var amountRange: ClosedRange<Int> {
        switch duration.unit {
        case .days:
            return 1...30
        case .weeks:
            return 1...4
        case .months:
            return 1...12
        }
    }

    private var sheetHeight: CGFloat {
        // Slightly taller for the wheel picker cases
        switch type {
        case .age, .expiresIn:
            return UIScreen.main.bounds.height * 0.2
        case .boolean:
            return UIScreen.main.bounds.height * 0.16
        }
    }
}
