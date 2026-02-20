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
    
    
    @State private var queue: [PantryQueueItem] // stack-type data structure that is initialized from the pantry model and manipulated in this view
    @State private var draftItem: PantryItem?
    @State private var draftID: PantryItem.ID?
    
    @State private var showFilterOptions: Bool = false

    // Optional filter applied once at session start
    private let filters: [PantryFilter]

    init(pantryVM: PantryViewModel, filters: [PantryFilter] = []) {
        self.pantryVM = pantryVM
        self.filters = filters

        _queue = State(
            initialValue: pantryVM.filteredItems
                .map { PantryQueueItem(id: $0.id) }
        )
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {

                SwipeCardStackView(items: queue, onAction: handleSwipe) { card in
                    if draftID == card.id, let _ = draftItem {
                        PantryItemView(
                            item: Binding(
                                get: { draftItem! },
                                set: { draftItem = $0 }
                            ),
                            availableLabels: pantryVM.getUserLabels(),
                            mode: .editNoDelete
                        )
                        .cardStyle()
                        .padding(.horizontal, 10)
                    } else if let item = pantryVM.getItemByID(itemID: card.id) {
                        // non-top cards: read-only rendering (no binding)
                        PantryItemView(
                            item: .constant(item),
                            availableLabels: pantryVM.getUserLabels(),
                            mode: .editNoDelete
                        )
                        .cardStyle()
                        .padding(.horizontal, 10)
                    } else {
                        EmptyPantryView(
                            tooltip: "No items to show here! Try adding items manually or through the scanner, or relax your filtering constraints."
                        )
                    }
                }


                bottomControls
                Spacer()
            }
            .navigationTitle("Manage Pantry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    FilterButtonView(
                        action: {
                            showFilterOptions = true
                        },
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
                    // TODO: We need to reset the queue to take the remaining items and apply the required filters to them
                    showFilterOptions = false
                },
                onCancel: {
                    pantryVM.filter = .init()
                    showFilterOptions = false
                }
            )
        }
        .activityBanner($banner)
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

        case .delete:
            print("Trying to delete")
            if let name = draftItem?.name {
                pantryVM.removeItem(itemID: id)
                showDeleteBanner(itemName: name)
            } else {
                pantryVM.removeItem(itemID: id)
            }
            queue.removeLast()
            loadDraftForTopCard()

        case .dismiss:
            queue.removeLast()
            loadDraftForTopCard()
        }
    }
}

private extension PantryOrganiseView {

    func showDeleteBanner(itemName: String) {
        withAnimation {
            banner = ActivityBanner(
                message: "Deleted \(itemName) from pantry",
                actionTitle: "Undo",
                action: {
                    pantryVM.undoLastRemoval()
                    banner = nil
                }
            )
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
                controlIcon(systemName: "hand.thumbsup.fill", color: .green)
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
