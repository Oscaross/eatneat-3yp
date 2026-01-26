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
    @Environment(\.dismiss) private var dismiss

    @StateObject private var agent = AgentModel()

    @State private var showScanner = false
    @State private var showHelp = false
    @State private var isProcessing = false
    @State private var processedItems: [PantryItem] = []
    @State private var showResults = false

    private let scannerSymbolName = "doc.viewfinder" // placeholder

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 18) {

                    // Scanner button
                    Button {
                        guard !isProcessing else { return }
                        processedItems = []
                        showResults = false
                        showScanner = true
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .fill(.thinMaterial)

                            VStack(spacing: 12) {
                                Image(systemName: scannerSymbolName)
                                    .font(.system(size: 72, weight: .semibold))
                                    .foregroundStyle(isProcessing ? .secondary : .primary)
                                    .symbolEffect(
                                        .pulse,
                                        options: isProcessing ? .repeating : .default,
                                        value: isProcessing
                                    )

                                Text(isProcessing ? "Processing…" : "Tap to scan")
                                    .font(.headline)
                                    .foregroundStyle(isProcessing ? .secondary : .primary)
                            }
                            .padding(.vertical, 26)
                        }
                        .frame(maxWidth: 360)
                    }
                    .buttonStyle(.plain)
                    .disabled(isProcessing)
                    .opacity(isProcessing ? 0.85 : 1.0)

                    // Description
                    Text("Scan any receipt-like document using your phone camera.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    // Guidance bullets
                    VStack(alignment: .leading, spacing: 10) {
                        bullet("You must have Internet access.")
                        bullet("Ensure the document is in a well-lit area or use the torch.")
                        bullet("Ensure the whole document is scanned, not just part.")
                        bullet("Ensure your camera is unobscured and clean.")
                    }
                    .padding()
                    .frame(maxWidth: 520, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(.thinMaterial)
                    )
                    .padding(.horizontal)

                    if isProcessing {
                        ProgressView("Processing receipt…")
                            .padding(.top, 6)
                    }

                    Spacer(minLength: 24)
                }
                .padding(.top, 16)
                .padding(.horizontal, 16)
            }
            .navigationTitle("Receipt Scanner")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showHelp = true
                    } label: {
                        Image(systemName: "questionmark.circle")
                    }
                }
            }

            // Results page
            .navigationDestination(isPresented: $showResults) {
                AfterScanView(scanned: processedItems, vm: pantryVM)
                    .navigationBarTitleDisplayMode(.inline)
            }

            // Help
            .sheet(isPresented: $showHelp) {
                HelpView(
                    title: "Receipt Scanner",
                    message: "Use your phone camera to scan receipt-like documents. Follow the guidance below to ensure accurate results.",
                    faqs: [
                        (
                            question: "Why do I need Internet access?",
                            answer: "Receipt processing uses online services to extract and normalise item data."
                        ),
                        (
                            question: "What lighting works best?",
                            answer: "Good, even lighting improves OCR accuracy. Use the torch if needed."
                        ),
                        (
                            question: "Should I scan the whole receipt?",
                            answer: "Yes. Partial scans may miss quantities or product names."
                        ),
                        (
                            question: "What if the scan looks wrong?",
                            answer: "Clean the camera lens and rescan with steadier framing."
                        )
                    ]
                )
            }

            // Scanner sheet
            .sheet(isPresented: $showScanner) {
                ReceiptScannerSheet(
                    pantryVM: pantryVM,
                    donationVM: donationVM,
                    agent: agent,
                    isProcessing: $isProcessing
                ) { items in
                    processedItems = items
                    showResults = true
                }
            }
        }
    }

    // Bullet helper
    private func bullet(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Text("•")
                .font(.body.weight(.semibold))
                .padding(.top, 1)
            Text(text)
                .font(.body)
                .foregroundStyle(.secondary)
        }
    }
}



// MARK: - Sheet wrapper that runs OCR -> async processing -> closes sheet

private struct ReceiptScannerSheet: View {
    @ObservedObject var pantryVM: PantryViewModel
    @ObservedObject var donationVM: DonationViewModel
    @ObservedObject var agent: AgentModel
    @Binding var isProcessing: Bool

    let onComplete: ([PantryItem]) -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ReceiptScannerView { lines in
            Task { @MainActor in
                isProcessing = true
                let ctx = AgentContext(
                    pantry: pantryVM,
                    donation: donationVM,
                    scannedItems: []
                )

                do {
                    try await ReceiptParser(agent: agent, context: ctx)
                        .parse(lines: lines)

                    let items = ctx.scannedItems ?? []

                    dismiss()

                    // Defer navigation until after dismissal starts
                    DispatchQueue.main.async {
                        onComplete(items)
                    }
                } catch {
                    print("Receipt parsing failed:", error)
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
