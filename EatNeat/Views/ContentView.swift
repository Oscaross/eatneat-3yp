import SwiftUI

struct ContentView: View {
    @EnvironmentObject var pantryViewModel: PantryViewModel
    @EnvironmentObject var donationViewModel : DonationViewModel
    @EnvironmentObject var agentModel: AgentModel

    @State private var loadedSampleItems = false
    @State private var showingAddItem = false
    
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
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 30))
                }
                .tag(2)

            DonationView(viewModel: donationViewModel)
                .tabItem { Label("Donate", systemImage: "heart.circle.fill") }
                .tag(3)

            SettingsView()
                .tabItem { Label("Settings", systemImage: "gearshape.fill") }
                .tag(4)
        }
        .onChange(of: selectedTab) { oldValue, newValue in
            if newValue == 2 {
                // Middle tab tapped
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()

                showingAddItem = true

                // Return to previous tab
                selectedTab = lastNonMiddleTab
            } else {
                lastNonMiddleTab = newValue
            }
        }

        .sheet(isPresented: $showingAddItem) {
            ReceiptScannerPageView()
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
