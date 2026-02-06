//
//  AgentContext.swift
//  EatNeat
//
//  Created by Oscar Horner on 17/01/2026.
//
// Represents the necessary app variables, models or references that callback functions need for the MCP tools to cause changes in the app.

class AgentContext {
    init(pantry: PantryViewModel, donation: DonationViewModel, scannedItems: [PantryItem]? = nil) {
        self.pantry = pantry
        self.donation = donation
        self.scannedItems = scannedItems
    }
    
    let pantry: PantryViewModel // access users' current pantry data, propogate changes to the pantry
    let donation: DonationViewModel // access data around foodbanks, and propogate updates to these needs
    var scannedItems: [PantryItem]? // optional list of scanned items from the receipt scanner
}
