//
//  DonationView.swift
//  EatNeat
//
//  Created by Oscar Horner on 26/10/2025.
//

import SwiftUI

struct DonationView: View {
    @ObservedObject var viewModel: DonationViewModel
    @EnvironmentObject var pantryViewModel: PantryViewModel
    @EnvironmentObject var agentViewModel: AgentViewModel
    
    // --- Foodbank Info View ---
    @State private var selectedFoodbank: FoodbankNeeds? = nil
    @State private var showFoodbankSheet = false
    
    // --- Help Tooltip ---
    @State private var showHelpDialog: Bool = false
    
    // --- Refresh Button Tooltip ---
    @State private var isRefreshing = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.foodbanks.isEmpty {
                    Spacer()
                    ProgressView("Loading nearby foodbanks…")
                    Spacer()
                } else {
                    TabView {
                        ForEach(Array(viewModel.foodbanks.values), id: \.id) { foodbank in
                            FoodbankCardView(
                                foodbank: foodbank
                            )
                            .padding(.horizontal)
                            .onTapGesture {
                                handleFoodbankTap(foodbank)
                            }
                        }
                    }
                    .tabViewStyle(.page)
                    .indexViewStyle(.page(backgroundDisplayMode: .always))
                }
            }
            .navigationTitle("Donate")
            .toolbar {
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
                helpSheet
            }
            .sheet(item: $selectedFoodbank) { fb in
                FoodbankInfoView(foodbank: fb)
            }
        }
    }
    
    private func handleFoodbankTap(_ foodbank: FoodbankNeeds) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        selectedFoodbank = foodbank
        showFoodbankSheet = true

        Task {
            try await agentViewModel.triggerMCPTool(
                tool: .matchItemToNeeds,
                instructions: MCPInstructions.matchItemToNeedsInstructions(
                    needs: foodbank,
                    items: pantryViewModel.getAllItems()
                ),
                pantryViewModel: pantryViewModel,
                donationViewModel: viewModel
            )
        }
    }

    
    @ViewBuilder
    private var helpSheet: some View {
        HelpView(
            title: "Help",
            message: "Foodbanks often have an abundance of some goods and a shortage of other goods. Many families and individuals within the community rely on these items to feed and care for each other and their children. EatNeat helps you to identify what foodbanks within your local community desparately need, and what you have told the app you have that could help make a difference.",
            faqs: [
                (
                    "What are matches?",
                    "Matches are entries into your pantry that we believe could seriously help a foodbank with a shortage of that particular type of good."
                ),
                (
                    "Do I have to arrange to donate items?",
                    "No! Just follow the instructions for each foodbank to see how to help, whether that is a local drop-off point or the foodbank themselves."
                ),
                (
                    "How are foodbanks discovered?",
                    "EatNeat asks for your location while using the application to find foodbanks within a 25km radius. The data from these foodbanks is then displayed and matched to your individual situation."
                ),
                (
                    "Do I have to use the donation feature?",
                    "Nope, it is just a feature that is there to help users who are able to support local foodbanks to do so more efficiently. The application is primarily designed for helping individuals organise and manage their shopping and pantry."
                )
            ]
        )
    }
}
