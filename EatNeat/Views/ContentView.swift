import SwiftUI

struct ContentView: View {
    let viewModel = PantryViewModel()
    
    init() {
        #if DEBUG
        SampleData.generateSampleItems().forEach { viewModel.addItem(item: $0) }
        #endif
    }
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            PantryView(viewModel: viewModel)
                .tabItem {
                    Label("My Pantry", systemImage: "basket.fill")
                }
            DonationView()
                .tabItem {
                    Label("Give", systemImage: "heart.circle.fill")
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

#Preview
{
    ContentView()
}
