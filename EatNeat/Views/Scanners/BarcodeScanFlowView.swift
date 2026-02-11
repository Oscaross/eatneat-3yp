//
//  BarcodeScanFlowView.swift
//  EatNeat
//
//  Created by Oscar Horner on 07/02/2026.
//
// Uses the ScanFlow abstraction to build the barcode scanner flow

import SwiftUI

struct BarcodeScanFlowView: View {
    let agent: AgentModel
    @ObservedObject var agentContext: AgentContext
    
    var body: some View {
        ScanFlowView<String, BarcodeScannerView>(
            title: "Scan Barcode",
            description: "Scan a barcode to add the item to your pantry.",
            icon: "barcode.viewfinder",
            instructions: UserInstructions.barcodeInstructions(),
            skipPreferenceKey: "pref.scanning.skipBarcodeLanding",
            makeScanner: { onScan in
                BarcodeScannerView(onScan: onScan)
            },
            parseIntoContext: { barcode, ctx in
                try await BarcodeScanner(agent: agent, context: ctx).scan(barcode: barcode)
            },
            agent: agent,
            agentContext: agentContext
        )
    }

    @EnvironmentObject var pantryVM: PantryViewModel
}
