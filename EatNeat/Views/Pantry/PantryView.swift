import SwiftUI

struct PantryView: View {
    @ObservedObject var viewModel: PantryViewModel
    
    @State private var searchTerm = "" // search bar
    
    @State private var gridView = true // if false then pantry items rendered as lists
    @State private var categoriesHidden: Set<Category> = [] // categories that are hidden by the user
    
    @State private var showSortOptions = false
    @State private var sortingMode : SortingMode = .alphabetical // default to alphabetical sorting
    
    @State private var editorSheet: PantryEditorSheet? // shows the add or edit item sheet when called
    
    @State var showFilterOptions: Bool = false
    @State var filters: [PantryFilter] = [] 

    var body: some View {
        NavigationStack {
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
            .searchable(text: $searchTerm, prompt: "Search...")
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    FilterButtonView { showFilterOptions = true }
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
                    filters: filters,
                    onApply: { newFilters in
                        filters = newFilters
                        showFilterOptions = false
                    },
                    onCancel: {
                        showFilterOptions = false
                    }
                )
            }
        }
    }

    /// Filters PantryItem instances by Category and a search term, if non-empty. Search is case-insensitive.
    private func getItemsToRender(category: Category) -> [PantryItem]? {
        guard let items = viewModel.itemsByCategory[category] else { return nil }
        
        if searchTerm.isEmpty {
            return viewModel.applyFilters(_: filters,to: items)
        }
        
        return viewModel.applyFilters(
            _: filters,
            to: items.filter { $0.name.lowercased().contains(searchTerm.lowercased())}
        )
    }

    
    private func sortItems(by mode: SortingMode, items: [PantryItem]) -> [PantryItem] {
        switch mode {
        case .dateAddedNewest:
            return items.sorted { $0.dateAdded > $1.dateAdded }
        case .dateAddedOldest:
            return items.sorted { $0.dateAdded < $1.dateAdded }
        case .quantity:
            return items.sorted { $0.quantity > $1.quantity }
        case .alphabetical:
            return items.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        }
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
            CapsuleView(content: .icon(systemName: "magnifyingglass"), color: .blue, heavy: true, action: {print("Expand")})
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
