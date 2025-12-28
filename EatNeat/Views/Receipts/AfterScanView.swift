//
//  AfterScanView.swift
//  EatNeat
//
//  Created by Oscar Horner on 28/12/2025.
//

import SwiftUI

struct AfterScanView: View {
    @ObservedObject var pantryViewModel: PantryViewModel
    @State private var scannedItems: [PantryItem]
    
    @State private var selection = 0
    
    init(scanned: [PantryItem], vm: PantryViewModel) {
        _scannedItems = State(initialValue: scanned)
        self.pantryViewModel = vm
    }

    var body: some View {
        NavigationStack {
            TabView(selection: $selection) {
                ForEach(scannedItems.indices, id: \.self) { i in
                    Form {
                        PantryItemFormView(item: $scannedItems[i])
                    }
                    .tag(i)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .automatic))
            .navigationTitle("Review Items (\(selection + 1)/\(scannedItems.count))")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add All") {
                        scannedItems.forEach {
                            pantryViewModel.addItem(item: $0)
                        }
                    }
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        // dismiss if presented
                    }
                }
            }
        }
    }
}

