import SwiftUI

struct ContentView: View {
    @EnvironmentObject var bridge: AppBridge
    
    let pantryViewModel = PantryViewModel()
    @EnvironmentObject var locationManager: LocationManager
    
    init() {
        #if DEBUG
        SampleData.generateSampleItems().forEach { pantryViewModel.addItem(item: $0) }
        #endif
    }
    
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
            DonationView(locationManager: locationManager)
                .tabItem {
                    Label("Donate", systemImage: "heart.circle.fill")
                }
        }
        .onReceive(bridge.$pendingCommands) { commands in
            guard let cmd = commands.last else { return }
            handleBridgeCommand(cmd)
            bridge.consumeCommand(cmd)
        }
    }
        
    
    func handleBridgeCommand(_ cmd: BridgeCommand) {
        switch cmd.action {
        case "showPopup":
            print("Received command successfully: \(cmd)")
        case "mapNeedToItem":
            print("Mapping need to item: \(cmd)")
        default:
            print("Unknown bridge command: \(cmd.action)")
        }
    }
}

struct HomeView: View {
    var body: some View {
        NavigationStack {
            Text("Home Page")
                .navigationTitle("EatNeat")
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(LocationManager())
}
