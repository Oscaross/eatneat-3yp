import SwiftUI

struct PantryView: View {
    @ObservedObject var viewModel: PantryViewModel
    
    @State private var searchTerm = "" // search bar
    
    @State private var gridView = true // if false then pantry items rendered as lists
    @State private var categoriesHidden: Set<Category> = [] // categories that are hidden by the user
    
    @State private var showSortOptions = false
    @State private var sortingMode : SortingMode = .alphabetical // default to alphabetical sorting
    
    @State private var showManagePantry = false // show the swiping to organise view
    
    @State private var editorSheet: PantryEditorSheet? // shows the add or edit item sheet when called

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

                    Button {
                        gridView.toggle()
                    } label: {
                        Image(systemName: gridView ? "square.grid.2x2" : "list.bullet")
                    }

                    Button {
                        showSortOptions = true
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                    .confirmationDialog(
                        "Sort Items",
                        isPresented: $showSortOptions,
                        titleVisibility: .visible
                    ) {
                        ForEach(SortingMode.allCases, id: \.self) { mode in
                            Button(mode.rawValue) {
                                sortingMode = mode
                            }
                        }
                        Button("Cancel", role: .cancel) {}
                    }

                    Button {
                        showManagePantry = true
                    } label: {
                        Image(systemName: "rectangle.stack")
                    }
                }
            }
            .sheet(item: $editorSheet) { sheet in
                PantryItemEditorSheet(
                    sheet: sheet,
                    pantryVM: viewModel
                )
            }
            .sheet(isPresented: $showManagePantry) {
                PantryOrganiseView(pantryVM: viewModel)
            }
        }
    }

    /// Filters PantryItem instances by Category and a search term, if non-empty. Search is case-insensitive.
    private func getItemsToRender(category: Category) -> [PantryItem]? {
        guard let items = viewModel.itemsByCategory[category] else { return nil }

        if searchTerm.isEmpty {
            return sortItems(by: sortingMode, items: items)
        }

        return sortItems(
            by: sortingMode,
            items: items.filter { $0.name.lowercased().contains(searchTerm.lowercased()) }
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
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 16) {
                ForEach(items) { item in
                    PantryItemCardView(item: item) {
                        editorSheet = .edit(item)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .listRowInsets(EdgeInsets()) // full-width row
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
