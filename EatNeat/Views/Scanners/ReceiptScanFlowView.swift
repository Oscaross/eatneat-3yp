//
//  ReceiptScanFlowView.swift
//  EatNeat
//
//  Created by Oscar Horner on 07/02/2026.
//
// Uses the ScanFlow abstraction to build the receipt scanner flow

import SwiftUI

struct ReceiptScanFlowView: View {
    let agent: AgentModel
    @ObservedObject var agentContext: AgentContext
    
    var body: some View {
        ScanFlowView<[OCRLine], ReceiptScannerView>(
            title: "Scan Receipt",
            description: "Scan a receipt-type document to automatically add items to your pantry.",
            icon: "doc.viewfinder",
            instructions: UserInstructions.receiptInstructions(),
            skipPreferenceKey: "pref.scanning.skipReceiptLanding",
            makeScanner: { onScan in
                ReceiptScannerView(onLinesExtracted: onScan)
            },
            parseIntoContext: { lines, ctx in
                try await ReceiptParser(agent: agent, context: ctx)
                    .parse(lines: lines)
            },
            agent: agent,
            agentContext: agentContext
        )
    }
}

