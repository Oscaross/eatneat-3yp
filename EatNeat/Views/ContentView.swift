import SwiftUI

struct ContentView: View {
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
