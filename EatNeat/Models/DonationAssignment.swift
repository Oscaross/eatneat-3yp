//
//  DonationAssignment.swift
//  EatNeat
//
//  Created by Oscar Horner on 04/12/2025.
//

import Foundation

struct DonationAssignment: Identifiable {
    let id = UUID()
    var item: PantryItem
    var recipient: FoodbankNeeds
    var isSelected: Bool = false
    
    init(item: PantryItem, recipient: FoodbankNeeds) {
        self.item = item
        self.recipient = recipient
    }
}
