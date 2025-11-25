import SwiftUI

struct ContentView: View {
    @EnvironmentObject var bridge: AppBridge
    @EnvironmentObject var pantryViewModel: PantryViewModel
    @EnvironmentObject var donationViewModel : DonationViewModel
    
    @State private var loadedSampleItems = false
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            PantryView(viewModel: pantryViewModel)
                .tabItem {
                    Label("My Pantry", systemImage: "basket.fill")
                }
            DonationView(viewModel: donationViewModel)
                .tabItem {
                    Label("Donate", systemImage: "heart.circle.fill")
                }
        }
        .onReceive(bridge.$pendingCommands) { commands in
            guard let cmd = commands.last else { return }
            handleBridgeCommand(cmd)
            bridge.consumeCommand(cmd)
        }
        .onAppear {
            #if DEBUG
            pantryViewModel.clearPantry()
            print("Loading sample data...")
            
            if !loadedSampleItems {
                SampleData.generateSampleItems().forEach {
                    pantryViewModel.addItem(item: $0)
                }
                loadedSampleItems = true
            }
            #endif
        }
    }
        
    /// Given a command arriving at the root (this) from the AppBridge, send to the relevant model/component of the app
    func handleBridgeCommand(_ cmd: BridgeCommand) {
        switch cmd {
        case .showPopup(_, let message):
            print("Received showPopup command, message: \(message)")

        case .matchItemToNeed(_, let foodbankID, let needID, let itemID):
            print("Mapping need to item → foodbankID: \(foodbankID), needID: \(needID), itemID: \(itemID)")
            donationViewModel.matchItemToNeed(foodbankID: foodbankID, needID: needID, itemID: itemID)
        }
    }

}
