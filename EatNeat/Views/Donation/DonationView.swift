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
    @EnvironmentObject var agentModel: AgentModel
    
    // --- Foodbank Info View ---
    @State private var selectedFoodbank: FoodbankNeeds? = nil
    
    // --- Help Tooltip ---
    @State private var showHelpDialog: Bool = false
    
    // --- Refresh Button Tooltip ---
    @State private var isRefreshing = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // --- Foodbank slider / pager ---
                if viewModel.foodbanks.isEmpty {
                    Spacer()
                    ProgressView("Loading nearby foodbanks…")
                    Spacer()
                } else {
                    TabView {
                        ForEach(Array(viewModel.foodbanks.values), id: \.id) { foodbank in
                            FoodbankCardView(foodbank: foodbank)
                                .padding(.horizontal)
                                .onTapGesture {
                                    handleFoodbankTap(foodbank)
                                }
                        }
                    }
                    .tabViewStyle(.page)
                    .indexViewStyle(.page(backgroundDisplayMode: .always))
                }
                
                // --- Donation collection area ---
                donationCollectionSection
            }
            .navigationTitle("Donate")
            .toolbar {
                // --- action icons ---
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button {
                        if !isRefreshing {
                            Task {
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
    
    // MARK: - Donation Collection Section

    @ViewBuilder
    private var donationCollectionSection: some View {
        
        if !viewModel.donations.isEmpty {
            
            VStack(alignment: .leading, spacing: 8) {
                
                // --- Title + Button ---
                HStack {
                    Text("Donation Collection")
                        .font(.headline)
                    
                    Spacer()
                    
                    Button {
                        processDonations()
                        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                        
                    } label: {
                        Text("Mark Donated")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                    .disabled(!viewModel.donations.contains(where: { $0.isSelected }))
                }
                
                .padding(.bottom, 6)
                
                // --- Column headers ---
                HStack {
                    Text("ITEM")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("RECIPIENT")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("") // checkmark column
                        .frame(width: 30)
                }
                
                Divider()
                
                // --- Table Rows ---
                ScrollView {
                    VStack(spacing: 4) {
                        ForEach($viewModel.donations) { $donation in
                            HStack {
                                Text(donation.item.name)
                                    .font(.subheadline)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Text(donation.recipient.name)
                                    .font(.subheadline)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Button {
                                    donation.isSelected.toggle()
                                } label: {
                                    Image(systemName: donation.isSelected
                                          ? "checkmark.circle.fill"
                                          : "circle")
                                        .foregroundColor(AppStyle.primary)
                                }
                                .buttonStyle(.plain)
                                .frame(width: 30)
                            }
                            .padding(.vertical, 6)
                        }
                    }
                }
                .frame(maxHeight: UIScreen.main.bounds.height * 0.25)
                
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
            )
            .padding(.horizontal)
            
        } else {
            
            // Empty State (unchanged)
            VStack(alignment: .leading, spacing: 8) {
                Text("Donation Collection")
                    .font(.headline)
                
                Text("Items you plan to donate will appear here once you select matches from foodbanks.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
            )
            .padding(.horizontal)
        }
    }

    
    // MARK: - Logic
    
    private func handleFoodbankTap(_ foodbank: FoodbankNeeds) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        selectedFoodbank = foodbank

        // TODO: MCP is disabled now we know it is working. It will be enabled once the frontend and backend is prepared.
        
        print(MCPInstructions.matchItemToNeedsInstructions(needs: foodbank, items: pantryViewModel.getAllItems()))
        
//        Task {
//            try await agentViewModel.triggerMCPTool(
//                tool: .matchItemToNeeds,
//                instructions: MCPInstructions.matchItemToNeedsInstructions(
//                    needs: foodbank,
//                    items: pantryViewModel.getAllItems()
//                ),
//                pantryViewModel: pantryViewModel,
//                donationViewModel: viewModel
//            )
//        }
        
        // TODO: Remove temporary debug for spawning many items to donate
        Task {
            // Get all pantry items
            let items = pantryViewModel.getAllItems()
            guard !items.isEmpty else { return }

            // Ensure the foodbank has needs to choose from
            guard !foodbank.needsList.isEmpty else { return }

            // We must use a var because registerMatch mutates foodbank
            var fbCopy = foodbank

            // Clear old donations before adding new debug ones
            viewModel.donations.removeAll()

            for item in items {
                // Pick a random need
                if let randomNeed = fbCopy.needsList.randomElement() {
                    let id = randomNeed.id

                    // Register match on the foodbank object
                    fbCopy.registerMatch(needId: id, item: item)

                    // Push to UI collection area
                    let assignment = DonationAssignment(item: item, recipient: fbCopy)
                    viewModel.donations.append(assignment)
                }
            }

            print("[DEBUG] Added \(viewModel.donations.count) fake donation matches.")
        }
        
    }
    
    private func processDonations() {
        let itemsToDonate = viewModel.donations.filter { $0.isSelected }
        
        for donation in itemsToDonate {
            pantryViewModel.markItemDonated(item: donation.item)
        }
    }

    // MARK: - Help Sheet
    
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
