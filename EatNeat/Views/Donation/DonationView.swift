//
//  DonationView.swift
//  EatNeat
//
//  Created by Oscar Horner on 26/10/2025.
//

import SwiftUI

struct DonationView: View {
    @EnvironmentObject var locationManager: LocationManager
    @StateObject private var viewModel: DonationViewModel
    
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
                        }
                    }
                    .tabViewStyle(.page)
                    .indexViewStyle(.page(backgroundDisplayMode: .always))
                    .frame(height: 280)
                }
            }
            .navigationTitle("Donate")
            .toolbar {
                // --- location indicator ---
                // removed for now because I can't get it to look good

                // --- action icons ---
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        // TODO: Refresh logic (e.g. re-fetch foodbank needs)
                        print("Refresh tapped")
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }

                    Button {
                        // TODO: Help or info sheet
                        print("Help tapped")
                    } label: {
                        Image(systemName: "questionmark.circle")
                    }
                }
            }
            .task {
                await viewModel.loadFoodbanks()
            }
        }
    }
    
    private func formattedDistance(_ distance: Double?) -> String {
        guard let d = distance else { return "–" }
        return d >= 1000 ? String(format: "%.1f km", d / 1000.0)
                         : String(format: "%.0f m", d)
    }
}
