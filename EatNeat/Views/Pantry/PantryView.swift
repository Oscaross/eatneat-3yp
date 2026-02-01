import SwiftUI
import CoreHaptics

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
            ZStack(alignment: .bottomTrailing) {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(Category.allCases, id: \.self) { category in
                            if let items = getItemsToRender(category: category), !items.isEmpty {
                                VStack(alignment: .leading, spacing: 10) {
                                    
                                    // MARK: Category header
                                    
                                    Text(category.rawValue + " (\(items.count))")
                                        .font(AppStyle.Text.sectionHeader)
                                        .foregroundColor(Color.blue.opacity(0.8))
                                        .padding(.leading) // leading padding only

                                    // Grid-based view
                                    if gridView {
                                        ScrollView(.horizontal, showsIndicators: false) {
                                            LazyHStack(spacing: 16) {
                                                ForEach(items) { item in
                                                    PantryItemCardView(item: item) {
                                                        editorSheet = .edit(item)
                                                    }
                                                }
                                            }
                                            .padding(.horizontal)
                                        }
                                    }
                                    // List-based view
                                    else {
                                        PantryTableSection(items: items)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.top)
                }
                .searchable(text: $searchTerm, prompt: "Search...")
                .toolbar {
                    ToolbarItemGroup(placement: .topBarTrailing) {
                        // Grid toggle button
                        Button {
                            gridView.toggle()
                        } label: {
                            Image(systemName: gridView ? "square.grid.2x2" : "list.bullet")
                                .font(.system(size: 18, weight: .medium))
                        }

                        // Sorting button
                        Button {
                            showSortOptions = true
                        } label: {
                            Image(systemName: "arrow.up.arrow.down")
                                .font(.system(size: 18, weight: .medium))
                        }
                        .confirmationDialog("Sort Items", isPresented: $showSortOptions, titleVisibility: .visible) {
                            ForEach(SortingMode.allCases, id: \.self) { mode in
                                Button(mode.rawValue) {
                                    sortingMode = mode
                                }
                            }
                            Button("Cancel", role: .cancel) {}
                        }
                        
                        // Organisation view toggle
                        Button {
                            showManagePantry = true
                        } label: {
                            Image(systemName: "rectangle.stack")
                                .font(.system(size: 18, weight: .medium))
                        }
                    }
                }

                // --- Add Button ---
                Button(action: {
                    editorSheet = .add
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .frame(
                            width: min(UIScreen.main.bounds.width * 0.15, 70),
                            height: min(UIScreen.main.bounds.width * 0.15, 70)
                        )
                        .background(AppStyle.primary)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                }
                .padding(.bottom, 24)
                .padding(.trailing, 24)
            }
            .navigationTitle("My Pantry")
            .sheet(item: $editorSheet) { sheet in
                PantryItemEditorSheet(
                    sheet: sheet,
                    pantryVM: viewModel
                )
            }
            .sheet(isPresented: $showManagePantry) {
                PantryOrganiseView(items: viewModel.getAllItems(), pantryVM: viewModel)
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
        }
        .cardStyle(padding: 8, cornerRadius: 4)
    }
}
