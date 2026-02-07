import SwiftUI

struct ContentView: View {
    @EnvironmentObject var pantryViewModel: PantryViewModel
    @EnvironmentObject var donationViewModel : DonationViewModel
    @EnvironmentObject var agentModel: AgentModel

    @State private var loadedSampleItems = false
    
    @State private var showingAddView = false // can we see the adder page?
    @State private var addMode: AddItemMode? // are we using receipt scanner, barcode scanner or manual add?
    
    @State private var selectedTab: Int = 0
    @State private var lastNonMiddleTab: Int = 0

    var body: some View {
        TabView(selection: $selectedTab) {

            HomeView()
                .tabItem { Label("Home", systemImage: "house") }
                .tag(0)

            PantryView(viewModel: pantryViewModel)
                .tabItem { Label("Pantry", systemImage: "basket.fill") }
                .tag(1)

            // MARK: Middle action button
            Color.clear
                .tabItem {
                    Label("Add", systemImage: "plus.circle.fill")
                }
                .tag(2)

            DonationView(viewModel: donationViewModel)
                .tabItem { Label("Donate", systemImage: "heart.circle.fill") }
                .tag(3)

            CustomiseView()
                .tabItem { Label("Customise", systemImage: "slider.horizontal.3") }
                .tag(4)
        }
        .onChange(of: selectedTab) { oldValue, newValue in
            if newValue == 2 {
                // Middle tab tapped
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()

                showingAddView = true

                // Return to previous tab
                selectedTab = lastNonMiddleTab
            } else {
                lastNonMiddleTab = newValue
            }
        }

        .sheet(isPresented: $showingAddView) {
            AddItemModeView { mode in
                addMode = mode
            }
        }
        // after we've picked the item entry mode show the relevant adder page
        .sheet(item: $addMode) { mode in
            switch mode {
            case .receipt:
                ReceiptScanFlowView(agent: agentModel, agentContext: AgentContext(pantry: pantryViewModel, donation: donationViewModel))
            case .barcode:
                EmptyView()
            case .manual:
                PantryItemEditorSheet(
                    sheet: .add,
                    pantryVM: pantryViewModel
                )
            case .organise:
                PantryOrganiseView(pantryVM: pantryViewModel)
            }
        }
        .onAppear {
            #if DEBUG
            pantryViewModel.clearPantry()
            if !loadedSampleItems {
                SampleData.generateSampleItems().forEach {
                    pantryViewModel.addItem(item: $0)
                }
                loadedSampleItems = true
            }
            #endif
        }
    }
}
