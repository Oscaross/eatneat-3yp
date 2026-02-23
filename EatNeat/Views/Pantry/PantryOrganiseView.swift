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
    @Environment(\.colorScheme) private var colorScheme
    
    @ObservedObject var pantryVM: PantryViewModel
    @EnvironmentObject var bannerManager: BannerManager

    // UI-only state
    @State private var initialQueueCount: Int = 0
    @State private var swipeProgress: Double = 0
    @State private var swipeDirection: SwipeCardAction?
    
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
                        queueProgressView
                        
                        SwipeCardStackView(
                            items: queue,
                            onAction: handleSwipe,
                            onSwipeProgress: { direction, progress in
                                swipeProgress = progress
                                swipeDirection = direction
                            }
                        ) { card in
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
                ToolbarItem(placement: .principal) {
                    queueCounter
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
        .onAppear {
            loadDraftForTopCard()
        }
        .activityBanner(_: $bannerManager.banner)
    }
    
    var queueCounter: some View {
        let total = max(initialQueueCount, 1)
        let currentIndex = total - queue.count + 1
        let clampedIndex = min(max(currentIndex, 1), total)

        
        return Text("\(clampedIndex) of \(total)")
            .font(.subheadline)
            .foregroundStyle(.secondary)
        
    }
    
    var queueProgressView: some View {
        let total = max(initialQueueCount, 1)
        return ProgressView(value: Double(total - queue.count), total: Double(total))
            .frame(maxWidth: 140)
    }
}


private extension PantryOrganiseView {
    
    private var topItem: PantryItem? {
        guard let id = draftID ?? queue.last?.id else { return nil }
        return pantryVM.getItemByID(itemID: id)
    }

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
                bannerManager.spawn(.removedItem(name: name, undo: {
                    pantryVM.undoLastRemoval()
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }))
            }
            
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
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
            .scaleEffect(swipeDirection == .delete ? 1 + swipeProgress / 2 : 1)
            .animation(.interactiveSpring(response: 0.25, dampingFraction: 0.7),
                       value: swipeDirection == .delete ? swipeProgress / 2 : 0)

            Spacer()

            if let item = topItem {
                Text("Added \(TimeUnit.compactRelativeString(from: item.dateAdded))")
                    .chipStyle(background: getChipColor(interval: Date().timeIntervalSince(item.dateAdded)))
            }

            Spacer()

            Button {
                handleSwipe(.approve)
            } label: {
                controlIcon(systemName: "checkmark", color: AppStyle.primary)
            }
            .scaleEffect(swipeDirection == .approve ? 1 + swipeProgress / 2 : 1)
            .animation(.interactiveSpring(response: 0.25, dampingFraction: 0.7),
                       value: swipeDirection == .approve ? swipeProgress / 2 : 0)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 16)
    }
    
    func getChipColor(interval: TimeInterval) -> Color {
        if (interval <= 14 * 24 * 60 * 60) {
            return AppStyle.primary.opacity(AppStyle.backgroundOpacity(darkMode: colorScheme == .dark)) // <= 14 days old
        }
        else if (interval <= 30 * 24 * 60 * 60) {
            return .yellow.opacity(AppStyle.backgroundOpacity(darkMode: colorScheme == .dark)) // <= 30 days old (kinda old)
        }
        else {
            return .red.opacity(AppStyle.backgroundOpacity(darkMode: colorScheme == .dark)) // everything else (olddd)
        }
    }
}


private extension PantryOrganiseView {

    func controlIcon(systemName: String, color: Color) -> some View {
        Image(systemName: systemName)
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(color)
            .frame(width: 40, height: 40)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(color.opacity(AppStyle.backgroundOpacity(darkMode: colorScheme == .dark)))
            )
            .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
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
