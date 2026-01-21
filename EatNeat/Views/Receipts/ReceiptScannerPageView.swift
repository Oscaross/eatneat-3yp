//
//  ReceiptScannerPageView.swift
//  EatNeat
//
//  Created by Oscar Horner on 17/12/2025.
//

import SwiftUI

struct ReceiptScannerPageView: View {
    @EnvironmentObject var pantryVM: PantryViewModel
    @EnvironmentObject var donationVM: DonationViewModel

    @StateObject private var agent = AgentModel()

    @State private var showScanner = false
    @State private var isProcessing = false
    @State private var processedItems: [PantryItem] = []

    var body: some View {
        VStack {
            Button("Scan Receipt") { showScanner = true }

            // Only show AfterScan once processing has completed
            if !processedItems.isEmpty {
                AfterScanView(scanned: processedItems, vm: pantryVM)
            } else if isProcessing {
                ProgressView("Processing receipt...")
                    .padding()
            }
        }
        .sheet(isPresented: $showScanner) {
            ReceiptScannerSheet(
                pantryVM: pantryVM,
                donationVM: donationVM,
                agent: agent,
                isProcessing: $isProcessing,
                processedItems: $processedItems
            )
        }
    }
}

// MARK: - Sheet wrapper that runs OCR -> async processing -> closes sheet

private struct ReceiptScannerSheet: View {
    @ObservedObject var pantryVM: PantryViewModel
    @ObservedObject var donationVM: DonationViewModel
    @ObservedObject var agent: AgentModel
    @Binding var isProcessing: Bool
    @Binding var processedItems: [PantryItem]

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ReceiptScannerView { lines in
            Task {
                isProcessing = true
                let ctx = AgentContext(pantry: pantryVM, donation: donationVM)

                do {
                    let instructions = MCPInstructions.generateItemsFromReceiptInstructions(lines: lines.asReceiptLines())
                    // MARK: Request sent to agent
                    try await agent.triggerMCPTool(
                        handler: RegisterNewItemHandler(),
                        instructions: instructions,
                        context: ctx
                    )

                    dismiss()
                } catch {
                    print("Receipt MCP failed:", error)
                    dismiss()
                }

                isProcessing = false
            }
        }
    }
}

/// Formatter - converts remaining OCR lines to plain text receipt format after pre-processing.
extension Array where Element == OCRLine {

    /// Returns receipt lines in visual top to bottom order, cleaned and ready for parsing.
    func asReceiptLines() -> [String] {
        self
            .sorted { $0.boundingBox.maxY > $1.boundingBox.maxY } // bottom-left is the origin
            .map { $0.text.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
    }
}
