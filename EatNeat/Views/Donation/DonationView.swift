//
//  DonationView.swift
//  EatNeat
//
//  Created by Oscar Horner on 26/10/2025.
//

import SwiftUI

struct DonationView: View {
    // --- Foodbank Info View ---
    @State private var selectedFoodbank: FoodbankNeeds? = nil
    @State private var showFoodbankSheet = false
    
    // --- Help Tooltip ---
    @State private var showHelpDialog: Bool = false
    
    // --- API ---
    @EnvironmentObject var locationManager: LocationManager
    @StateObject private var viewModel: DonationViewModel
    
    // --- Refresh Button Tooltip ---
    @State private var isRefreshing = false
    
    init(locationManager: LocationManager) {
        _viewModel = StateObject(wrappedValue: DonationViewModel(locationManager: locationManager))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.foodbanks.isEmpty {
                    Spacer()
                    ProgressView("Loading nearby foodbanks…")
                    Spacer()
                } else {
                    TabView {
                        ForEach(viewModel.foodbanks, id: \.id) { foodbank in
                            FoodbankCardView(
                                name: foodbank.name,
                                needs: foodbank.mapNeedsToPantry(),
                                distance: formattedDistance(foodbank.distance)
                            )
                            .padding(.horizontal)
                            .onTapGesture {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                
                                selectedFoodbank = foodbank
                                showFoodbankSheet = true
                            }
                        }
                    }
                    .tabViewStyle(.page)
                    .indexViewStyle(.page(backgroundDisplayMode: .always))
                }
            }
            .navigationTitle("Donate")
            .toolbar {
                // --- location indicator ---
                // removed for now because I can't get it to look good

                // --- action icons ---
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        if !isRefreshing {
                            Task {
                                // allows us to make the loading sign spin
                                isRefreshing = true
                                await viewModel.loadFoodbanks()
                                isRefreshing = false
                            }
                        }
                    } label: {
                        if isRefreshing {
                            ProgressView()
                        } else {
                            Image(systemName: "arrow.clockwise")
                        }
                    }

                    Button {
                        showHelpDialog = true
                    } label: {
                        Image(systemName: "questionmark.circle")
                    }
                }
            }
            .task {
                await viewModel.loadFoodbanks()
            }
            .sheet(isPresented: $showHelpDialog) {
                HelpView(
                    title: "Help",
                    message: "Foodbanks often have an abundance of some goods and a shortage of other goods. Many families and individuals within the community rely on these items to feed and care for each other and their children. EatNeat helps you to identify what foodbanks within your local community desparately need, and what you have told the app you have that could help make a difference.",
                    faqs: [
                        ("What are matches?", "Matches are entries into your pantry that we believe could seriously help a foodbank with a shortage of that particular type of good."),
                        ("Do I have to arrange to donate items?", "No! Just follow the instructions for each foodbank to see how to help, whether that is a local drop-off point or the foodbank themselves."),
                        ("How are foodbanks discovered?", "EatNeat asks for your location while using the application to find foodbanks within a 25km radius. The data from these foodbanks is then displayed and matched to your individual situation."),
                        ("Do I have to use the donation feature?", "Nope, it is just a feature that is there to help users who are able to support local foodbanks to do so more efficiently. The application is primarily designed for helping individuals organise and manage their shopping and pantry."),
                        
                    ]
                )
            }
            .sheet(isPresented: $showFoodbankSheet) {
                if let fb = selectedFoodbank {
                    FoodbankInfoView(foodbank: fb)
                }
            }
        }
    }
    
    private func formattedDistance(_ distance: Double?) -> String {
        guard let d = distance else { return "–" }
        return d >= 1000 ? String(format: "%.1f km", d / 1000.0)
                         : String(format: "%.0f m", d)
    }
}

#Preview
{
    DonationView(locationManager: LocationManager())
}
