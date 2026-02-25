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
    @EnvironmentObject var settingsModel: SettingsModel
    @EnvironmentObject var bannerManager: BannerManager
    
    @State private var editorSheet: PantryEditorSheet? // shows the add or edit item sheet when called
    
    @State var showFilterOptions: Bool = false
    @State var showOrganiseView: Bool = false
    

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
                        if settingsModel.compactPantryView {
                            Group {
                                PantryTableSection(
                                    categoryName: category.rawValue,
                                    itemCount: items.count,
                                    items: items,
                                    onTapItem: { tapped in
                                        editorSheet = .edit(tapped)
                                    }
                                )
                                .listRowInsets(EdgeInsets())
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                            }
                        } else {
                            Section {
                                categoryHeader(category, count: items.count)
                                    .listRowInsets(EdgeInsets())
                                    .listRowSeparator(.hidden)

                                gridSection(items: items)
                            }
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .listStyle(.plain)
            .searchable(text: $viewModel.searchTerm, prompt: "Search my pantry...")
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Grid") {
                        
                    }
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    HStack {
                        Button(action: {
                            showOrganiseView = true
                        }) {
                            Label("Organise", systemImage: "rectangle.stack")
                        }
                        
                        Button(action: {
                            showFilterOptions = true
                        }) {
                            Label("Filter", systemImage: "line.3.horizontal.decrease")
                        }
                    }
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
                        bannerManager.spawn(_: .generic(message: "Filter applied to items."))
                    },
                    onCancel: {
                        showFilterOptions = false
                        bannerManager.spawn(_: .generic(message: "All active filters cleared."))
                    }
                )
            }
            .sheet(isPresented: $showOrganiseView) {
                PantryOrganiseView(pantryVM: viewModel)
            }
            .activityBanner(_: $bannerManager.banner)
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
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(AppStyle.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 6)
        .listRowBackground(Color.clear)
        .contentMargins(.horizontal, 0, for: .scrollContent)
    }
}

private extension PantryView {

    func gridSection(items: [PantryItem]) -> some View {
        
        let cardHeight = min(UIScreen.main.bounds.width * 0.32, 132)
        
        return ScrollView(.horizontal, showsIndicators: false) {
            
            if items.count <= 6 {
                
                LazyHStack(spacing: 16) {
                    ForEach(items) { item in
                        PantryItemCardView(item: item) {
                            editorSheet = .edit(item)
                        }
                    }
                }
                .padding(.horizontal, 8)
                
            } else {
                
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
                .padding(.horizontal, 8)
            }
        }
        .padding(.vertical, 4)
        .listRowInsets(EdgeInsets())
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
        .contentMargins(.horizontal, 0, for: .scrollContent)
    }
}




struct PantryTableSection: View {
    let categoryName: String
    let itemCount: Int
    let items: [PantryItem]
    let onTapItem: (PantryItem) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            
            // MARK: - Category Header
            VStack(spacing: 10) {
                
                // Combined title + count
                Text("\(categoryName) (\(itemCount))")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(AppStyle.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // Column markers
                HStack {
                    Text("NAME")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Text("AMOUNT")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 14)
            .padding(.bottom, 8)
            
            Divider()
            
            // MARK: - Rows
            ForEach(items) { item in
                PantryItemRowView(item: item)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        onTapItem(item)
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .strokeBorder(Color.white.opacity(0.12))
        )
        .shadow(color: .black.opacity(0.08), radius: 6, y: 3)
        
        .padding(.vertical, 12)
    }
}
