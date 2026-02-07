//
//  ScanFlowView.swift
//  EatNeat
//
//  Created by Oscar Horner on 07/02/2026.
//
// Defines a generic template for the flow of scanning items into the pantry, can apply to both a barcode scanner and a receipt scanner.

import SwiftUI

struct ScanFlowView<ScanOutput, Scanner: View>: View {
    let title: String
    let description: String
    let icon: String
    let instructions: [String]
    let skipPreferenceKey: String

    let makeScanner: (@escaping (ScanOutput) -> Void) -> Scanner
    let parseIntoContext: (ScanOutput, AgentContext) async throws -> Void

    let agent: AgentModel
    @ObservedObject var context: AgentContext
    
    @Environment(\.dismiss) private var dismiss

    @AppStorage private var skipLanding: Bool

    @State private var showScanner = false
    @State private var showResults = false
    @State private var isProcessing = false


    init(
        title: String,
        description: String,
        icon: String,
        instructions: [String],
        skipPreferenceKey: String,
        makeScanner: @escaping (@escaping (ScanOutput) -> Void) -> Scanner,
        parseIntoContext: @escaping (ScanOutput, AgentContext) async throws -> Void,
        agent: AgentModel,
        agentContext: AgentContext
    ) {
        self.title = title
        self.description = description
        self.icon = icon
        self.instructions = instructions
        self.skipPreferenceKey = skipPreferenceKey
        self.makeScanner = makeScanner
        self.parseIntoContext = parseIntoContext
        self.agent = agent
        self.context = agentContext
        self._skipLanding = AppStorage(wrappedValue: false, skipPreferenceKey)
    }

    var body: some View {
        NavigationStack {
            Group {
                if skipLanding {
                    landinglessBody
                } else {
                    ScannerLandingView(
                        sheetTitle: title,
                        sheetDescription: description,
                        sheetIcon: icon,
                        instructions: instructions,
                        launchScanner: { showScanner = true },
                        dismiss: { dismiss() },
                        isProcessing: isProcessing
                    )
                }
            }
            .sheet(isPresented: $showScanner) {
                scannerSheet
            }
            .navigationDestination(isPresented: $showResults) {
                AfterScanView(
                    scanned: context.scannedItems ?? [],
                    vm: context.pantry
                ) {
                    showResults = false
                    dismiss()
                }
            }
        }
    }


    private var landinglessBody: some View {
        // auto-launch on appear if skipping landing
        Color.clear
            .onAppear { showScanner = true }
    }

    private var scannerSheet: some View {
        makeScanner { output in
            Task { @MainActor in
                isProcessing = true
                context.scannedItems = []

                do {
                    try await parseIntoContext(output, context)
                    showScanner = false
                    showResults = true
                } catch {
                    print("Parse failed:", error)
                    showScanner = false
                }

                isProcessing = false
            }
        }
    }
}
