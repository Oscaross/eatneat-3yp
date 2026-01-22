//
//  ReceiptItemSink.swift
//  EatNeat
//
//  Created by Oscar Horner on 22/01/2026.
// A sink protocol that defines how handlers register newly instantiated PantryItem instances and allows dependents to access these items.

@MainActor
final class ReceiptItemSink {
    private(set) var items: [PantryItem] = []

    func didCreateItem(_ item: PantryItem) {
        items.append(item)
    }
}
