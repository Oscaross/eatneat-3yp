//
//  PantryOrganiseView.swift
//  EatNeat
//
//  Created by Oscar Horner on 30/01/2026.
//
// Sheet view to allow users to organise their pantry, in a "swipe" type view filtering out unwanted or used up items quickly.

import SwiftUI

struct PantryOrganiseView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var pantryVM: PantryViewModel

    // UI-only state
    @State private var banner: ActivityBanner?
    @State private var initialQueueCount: Int = 0
    
    
    @State private var queue: [PantryQueueItem] // stack-type data structure that is initialized from the pantry model and manipulated in this view
    @State private var draftItem: PantryItem?
    @State private var draftID: PantryItem.ID?
    
    @State private var showFilterOptions: Bool = false

    // Optional filter applied once at session start
    private let filters: [PantryFilter]

    init(pantryVM: PantryViewModel, filters: [PantryFilter] = []) {
        self.pantryVM = pantryVM
        self.filters = filters

        let initial = pantryVM.filteredItems.map { PantryQueueItem(id: $0.id) }
        _queue = State(initialValue: initial)
        _initialQueueCount = State(initialValue: initial.count)
    }

    var body: some View {
        NavigationStack {
            Group {
                if queue.isEmpty {
                    EmptyOrganiseView()
                } else {
                    VStack(spacing: 16) {
                        queueCounter
                        
                        SwipeCardStackView(items: queue, onAction: handleSwipe) { card in
                            if draftID == card.id, draftItem != nil {
                                PantryItemView(
                                    item: Binding(
                                        get: { draftItem! },
                                        set: { draftItem = $0 }
                                    ),
                                    pantryVM: pantryVM,
                                    mode: .editNoDelete
                                )
                                .cardStyle()
                                .padding(.horizontal, 10)
                            } else if let item = pantryVM.getItemByID(itemID: card.id) {
                                PantryItemView(
                                    item: .constant(item),
                                    pantryVM: pantryVM,
                                    mode: .editNoDelete
                                )
                                .cardStyle()
                                .padding(.horizontal, 10)
                            } else {
                                EmptyView()
                            }
                        }

                        bottomControls
                        Spacer()
                    }
                }
            }
            .navigationTitle("Manage Pantry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    FilterButtonView(
                        action: { showFilterOptions = true },
                        filter: pantryVM.filter
                    )
                }
            }
        }
        .sheet(isPresented: $showFilterOptions) {
            FilterSheetView(
                pantryVM: pantryVM,
                filter: pantryVM.filter,
                onApply: { newFilter in
                    pantryVM.filter = newFilter
                    showFilterOptions = false
                },
                onCancel: {
                    pantryVM.filter = .init()
                    showFilterOptions = false
                }
            )
        }
        .activityBanner($banner)
        .onAppear {
            loadDraftForTopCard()
        }
    }
    
    var queueCounter: some View {
        let total = max(initialQueueCount, 1)
        let currentIndex = total - queue.count + 1
        let clampedIndex = min(max(currentIndex, 1), total)

        return HStack(spacing: 10) {
            Text("\(clampedIndex) of \(total)")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            ProgressView(value: Double(total - queue.count), total: Double(total))
                .frame(maxWidth: 140)
        }
    }
}


private extension PantryOrganiseView {

    func handleSwipe(_ action: SwipeCardAction) {
        guard let id = draftID else { return }

        switch action {
        case .approve:
            commitDraft(id: id)
            queue.removeLast()
            loadDraftForTopCard()
            
            UIImpactFeedbackGenerator(style: .light).impactOccurred()

        case .delete:
            let name = draftItem?.name

            withTransaction(Transaction(animation: nil)) {
                queue.removeLast()
                loadDraftForTopCard()
            }

            pantryVM.removeItem(itemID: id)

            if let name {
                showDeleteBanner(itemName: name)
            }
            
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
    }
}

private extension PantryOrganiseView {
    
    private func showDeleteBanner(itemName: String) {
        presentBanner(
            ActivityBanner(
                message: "Deleted \(itemName) from pantry",
                actionTitle: "Undo",
                action: {
                    pantryVM.undoLastRemoval()
                    banner = nil
                }
            )
        )
    }

    private func presentBanner(_ newBanner: ActivityBanner) {
        // Immediately clear any existing banner
        banner = nil
        
        // Small delay ensures SwiftUI processes the removal first
        DispatchQueue.main.async {
            withAnimation {
                banner = newBanner
            }
        }
    }
}

private extension PantryOrganiseView {

    var bottomControls: some View {
        HStack {
            Button {
                handleSwipe(.delete)
            } label: {
                controlIcon(systemName: "trash", color: .red)
            }

            Spacer()

            Button {
                handleSwipe(.approve)
            } label: {
                controlIcon(systemName: "checkmark", color: AppStyle.primary)
            }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 16)
    }
}


private extension PantryOrganiseView {

    func controlIcon(
        systemName: String,
        color: Color
    ) -> some View {
        Image(systemName: systemName)
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(color)
            .frame(width: 46, height: 46)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(color.opacity(0.12))
            )
    }
}

struct PantryQueueItem: Identifiable, Hashable {
    let id: PantryItem.ID
}

private extension PantryOrganiseView {

    func loadDraftForTopCard() {
        guard let topID = queue.last?.id else {
            draftItem = nil
            draftID = nil
            return
        }

        draftID = topID
        draftItem = pantryVM.getItemByID(itemID: topID) // value copy
    }

    func commitDraft(id: PantryItem.ID) {
        guard let draftItem else { return }
        pantryVM.updateItem(updatedItem: draftItem)
    }
}
