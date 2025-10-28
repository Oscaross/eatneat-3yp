import SwiftUI
import CoreHaptics

struct PantryView: View {
    @ObservedObject var viewModel: PantryViewModel
    @State private var showAddItem = false
    // -- Search --
    @State private var searchTerm = ""
    // -- Viewer --
    @State private var gridView = true // if false then pantry items rendered as lists
    @State private var categoriesHidden: Set<Category> = [] // categories that are hidden by the user
    // -- Sorting --
    @State private var showSortOptions = false
    @State private var sortingMode : SortingMode = .alphabetical // default to alphabetical sorting

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                // --- Main scroll content ---
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        ForEach(Category.allCases, id: \.self) { category in
                            if let items = getItemsToRender(category: category), !items.isEmpty {
                                VStack(alignment: .leading, spacing: 10) {
                                    
                                    // Category header
                                    HStack {
                                        Text(category.rawValue)
                                            .font(AppStyle.Text.sectionHeader)
                                            .foregroundColor(Color.blue.opacity(0.8))
                                            .padding(.leading) // leading padding only

                                        Spacer()

                                        // Hide/show category button
                                        Button {
                                            if categoriesHidden.contains(category) {
                                                categoriesHidden.remove(category)
                                            } else {
                                                categoriesHidden.insert(category)
                                            }
                                        } label: {
                                            Image(systemName: categoriesHidden.contains(category) ? "eye.slash" : "eye")
                                                .font(.system(size: 18, weight: .medium))
                                                .foregroundColor(Color.blue.opacity(0.8))
                                                .padding(.trailing, 12)
                                        }
                                    }
                                    .padding(.vertical, 6)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue.opacity(0.08))
                                    .cornerRadius(6)

                                    // Grid-based view
                                    if gridView {
                                        ScrollView(.horizontal, showsIndicators: false) {
                                            LazyHStack(spacing: 16) {
                                                ForEach(items, id: \.name) { item in
                                                    PantryItemCard(item: item)
                                                }
                                            }
                                            .padding(.horizontal)
                                        }
                                    }
                                    // List-based view
                                    else {
                                        VStack(spacing: 10) {
                                            ForEach(items, id: \.name) { item in
                                                PantryItemRow(item: item)
                                                    .padding(.horizontal)
                                            }
                                        }
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

                        // Sorting/filtering button placeholder
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
                    }
                }

                // --- Floating Add Button ---
                Button(action: {
                    showAddItem = true
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
            .sheet(isPresented: $showAddItem) {
                AddItemView(viewModel: viewModel)
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
