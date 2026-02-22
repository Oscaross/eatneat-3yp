//
//  PantryView.swift
//  EatNeat
//
//  Created by Oscar Horner on 30/09/2026.
//
// Root view for users to see their pantry and interact with it by filtering or searching for items. Displays all content related to their pantry.

import SwiftUI

struct PantryView: View {
    @ObservedObject var viewModel: PantryViewModel
    @State private var gridView = true // if false then pantry items rendered as lists
    
    @State private var editorSheet: PantryEditorSheet? // shows the add or edit item sheet when called
    
    @State var showFilterOptions: Bool = false

    var body: some View {
        NavigationStack {
            
            if viewModel.filteredItems.isEmpty {
                EmptyPantryView(
                    tooltip: "No items to show here! Try adding items manually or through the scanner, or relax your filtering constraints."
                )
            }
            
            List {
                ForEach(Category.allCases, id: \.self) { category in
                    if let items = getItemsToRender(category: category),
                       !items.isEmpty {
                        Section {
                            categoryHeader(category, count: items.count)
                                .listRowInsets(EdgeInsets())
                                .listRowSeparator(.hidden)

                            if gridView {
                                gridSection(items: items)
                            } else {
                                PantryTableSection(items: items)
                                    .listRowInsets(EdgeInsets())
                                    .listRowSeparator(.hidden)
                            }
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .listStyle(.plain)
            .navigationTitle("My Pantry")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $viewModel.searchTerm, prompt: "Search...")
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    FilterButtonView(
                        action: { showFilterOptions = true },
                        filter: viewModel.filter
                    )
                }
            }
            .sheet(item: $editorSheet) { sheet in
                PantryItemEditorSheet(
                    sheet: sheet,
                    pantryVM: viewModel
                )
            }
            .sheet(isPresented: $showFilterOptions) {
                FilterSheetView(
                    pantryVM: viewModel,
                    filter: viewModel.filter,
                    onApply: { newFilter in
                        viewModel.filter = newFilter
                        showFilterOptions = false
                    },
                    onCancel: { showFilterOptions = false }
                )
            }
        }
    }

    private func getItemsToRender(category: Category) -> [PantryItem]? {
        return viewModel.filteredItems
            .filter { $0.category == category }
    }
}

private extension PantryView {

    func categoryHeader(_ category: Category, count: Int) -> some View {
        HStack {
            Text("\(category.rawValue) (\(count))")
                .font(AppStyle.Text.sectionHeader)
                .foregroundStyle(.blue.opacity(0.85))
                .textCase(nil)
            Spacer()
            // CapsuleView(content: .icon(systemName: "magnifyingglass"), color: .blue, heavy: true, action: {print("Expand")})
        }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .padding(.vertical, 6)
            .background(
                Color.blue.opacity(0.08)
            )
    }
}

private extension PantryView {

    func gridSection(items: [PantryItem]) -> some View {

        let cardHeight = min(UIScreen.main.bounds.width * 0.32, 132)

        return ScrollView(.horizontal, showsIndicators: false) {

            if items.count <= 6 {

                // Original 1-high layout
                LazyHStack(spacing: 16) {
                    ForEach(items) { item in
                        PantryItemCardView(item: item) {
                            editorSheet = .edit(item)
                        }
                    }
                }

            } else {

                // 2-high infinite grid
                let rows = [
                    GridItem(.fixed(cardHeight), spacing: 16),
                    GridItem(.fixed(cardHeight), spacing: 16)
                ]

                LazyHGrid(rows: rows, spacing: 16) {
                    ForEach(items) { item in
                        PantryItemCardView(item: item) {
                            editorSheet = .edit(item)
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .listRowInsets(EdgeInsets())
        .listRowSeparator(.hidden)
    }
}




struct PantryTableSection: View {
    let items: [PantryItem]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // HEADER
            HStack {
                Text("NAME")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                Spacer()
                Text("STOCK")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            .padding(.vertical, 6)
            .background(AppStyle.containerGray)
            
            Divider()

            // ROWS
            VStack(spacing: 0) {
                ForEach(items) { item in
                    PantryItemRowView(item: item)
                }
            }
            .listRowSeparator(.hidden)
        }
        .cardStyle(padding: 8, cornerRadius: 4)
        
    }
}
